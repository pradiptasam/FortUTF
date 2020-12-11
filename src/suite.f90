MODULE FUTF_SUITE
    USE FUTF_UTILITIES, ONLY: APPEND_CHAR, APPEND_INT
    IMPLICIT NONE

    PUBLIC
    INTEGER :: FUTF_PASSED    = 0                   ! Number of FUTF_PASSED Tests
    INTEGER :: FUTF_TOTAL     = 0                   ! FUTF_TOTAL Number of Tests
    INTEGER :: FUTF_EXIT_CODE = 0                   ! Test Suite Exit Code
    CHARACTER(LEN=100) :: IDENTIFIER = "UNNAMED TEST"    ! String for Test Labels
    CHARACTER(LEN=100), DIMENSION(:), ALLOCATABLE :: TEST_NAMES
    CHARACTER(LEN=1), DIMENSION(:), ALLOCATABLE :: TEST_RESULTS
    CHARACTER(LEN=200), DIMENSION(:), ALLOCATABLE :: INFO_STRINGS

    CONTAINS

    SUBROUTINE TAG_TEST(TEST_NAME)
        CHARACTER(LEN=*), INTENT(IN) :: TEST_NAME
        IDENTIFIER = TEST_NAME
    END SUBROUTINE

    SUBROUTINE REGISTER_FAILED
        FUTF_TOTAL  = FUTF_TOTAL + 1
        TEST_RESULTS = APPEND_CHAR(TEST_RESULTS, 'F', 1)
        TEST_NAMES = APPEND_CHAR(TEST_NAMES, IDENTIFIER, LEN(IDENTIFIER))
        FUTF_EXIT_CODE = 1
        IDENTIFIER = "UNNAMED TEST"
    END SUBROUTINE

    SUBROUTINE REGISTER_PASSED
        FUTF_PASSED = FUTF_PASSED + 1
        FUTF_TOTAL  = FUTF_TOTAL + 1
        TEST_RESULTS = APPEND_CHAR(TEST_RESULTS, '.', 1)
        TEST_NAMES = APPEND_CHAR(TEST_NAMES, IDENTIFIER, LEN(IDENTIFIER))
        IDENTIFIER = "UNNAMED TEST"
    END SUBROUTINE

    SUBROUTINE FAILED_TEST_SUMMARY

        INTEGER, DIMENSION(:), ALLOCATABLE :: IFAILED
        INTEGER :: NTESTS, N_FAILED, I
        LOGICAL :: PRINT_NAMED_FAILED_TESTS = .TRUE.

        NTESTS = SIZE(TEST_NAMES)
        N_FAILED = FUTF_TOTAL-FUTF_PASSED

        DO I=1, NTESTS
            IF(TEST_RESULTS(I) == 'F') THEN
                IFAILED = APPEND_INT(IFAILED, I)
            ENDIF
        ENDDO

        IF(FUTF_TOTAL-FUTF_PASSED == 0) THEN
            RETURN
        ENDIF

        DO I=1, SIZE(IFAILED)
            IF(TEST_NAMES(IFAILED(I)) /= "UNNAMED TEST") THEN
                IF(PRINT_NAMED_FAILED_TESTS) THEN
                    WRITE(*,*) "THE FOLLOWING TESTS FAILED: ", NEW_LINE('A')
                    PRINT_NAMED_FAILED_TESTS = .FALSE.
                ENDIF
                WRITE(*,*) "  - ", TEST_NAMES(IFAILED(I))
                WRITE(*,*) REPEAT(" ", 10), TRIM(INFO_STRINGS(IFAILED(I))), NEW_LINE('A')
            ENDIF
        ENDDO

    END SUBROUTINE

    SUBROUTINE TEST_SUMMARY(QUIET)
        LOGICAL, OPTIONAL :: QUIET
        CHARACTER(LEN=100) :: RESULT_STR, N_TEST_STR

        IF(.NOT. ALLOCATED(TEST_RESULTS) .OR. .NOT. ALLOCATED(INFO_STRINGS)) THEN
            IF(.NOT. PRESENT(QUIET)) THEN
                WRITE(*,*) "No Tests Found."
            ENDIF
            RETURN
        ENDIF
        
        IF(.NOT. PRESENT(QUIET)) THEN
            WRITE(*,*) REPEAT("-", 54)
            WRITE(N_TEST_STR, '(A, i0, A)') "GATHERED ",SIZE(TEST_RESULTS)," TESTS:"
            WRITE(*,*) TRIM(N_TEST_STR), " ", TEST_RESULTS
            WRITE(*,*) REPEAT("-", 54), NEW_LINE('A')
        ENDIF
        CALL FAILED_TEST_SUMMARY
        IF(.NOT. PRESENT(QUIET)) THEN
            WRITE(*,*) NEW_LINE('A')
            WRITE(RESULT_STR, '(A, i0, A, i0)') REPEAT(" ", 5)//"PASSED: ", FUTF_PASSED, "/", FUTF_TOTAL
            WRITE(*,*) REPEAT("*", 20), " TEST SUMMARY ", REPEAT("*", 20), NEW_LINE('A')
            WRITE(*,*) RESULT_STR, NEW_LINE('A')
            WRITE(*,*) REPEAT("*", 54)
        ENDIF
    END SUBROUTINE
        
END MODULE
