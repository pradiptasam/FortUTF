MODULE FUTF_SPECIALS
    USE FUTF_SUITE, ONLY: FUTF_TOTAL, FUTF_PASSED

    IMPLICIT NONE

    CONTAINS

    SUBROUTINE FAIL
        FUTF_TOTAL = FUTF_TOTAL + 1
    END SUBROUTINE FAIL

    SUBROUTINE SUCCEED
        FUTF_TOTAL = FUTF_TOTAL + 1
        FUTF_PASSED = FUTF_PASSED + 1
    END SUBROUTINE SUCCEED

END MODULE FUTF_SPECIALS