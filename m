From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:review-tracepoints 1/5] include/linux/kernfs.h:350:1: error:
 expected identifier or '(' before '{' token
Date: Tue, 9 Aug 2016 13:39:25 +0800
Message-ID: <201608091323.Ury5GhW4%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-tracepoints
head:   471f89b317a21a78dacaee85957984b9f11e79e4
commit: 5f8ffbe607d1bb405d6f57735a4e214879b3d646 [1/5] kernfs: add dummy implementation of kernfs_path_from_node()
config: i386-tinyconfig (attached as .config)
compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        git checkout 5f8ffbe607d1bb405d6f57735a4e214879b3d646
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   In file included from include/linux/cgroup.h:18:0,
                    from include/linux/memcontrol.h:22,
                    from include/linux/swap.h:8,
                    from include/linux/suspend.h:4,
                    from arch/x86/kernel/asm-offsets.c:12:
>> include/linux/kernfs.h:350:1: error: expected identifier or '(' before '{' token
    { return -ENOSYS; }
    ^
   include/linux/kernfs.h:347:19: warning: 'kernfs_path_from_node' declared 'static' but never defined [-Wunused-function]
    static inline int kernfs_path_from_node(struct kernfs_node *root_kn,
                      ^~~~~~~~~~~~~~~~~~~~~
   make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [prepare0] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [sub-make] Error 2

vim +350 include/linux/kernfs.h

   344	static inline size_t kernfs_path_len(struct kernfs_node *kn)
   345	{ return 0; }
   346	
   347	static inline int kernfs_path_from_node(struct kernfs_node *root_kn,
   348						struct kernfs_node *kn,
   349						char *buf, size_t buflen);
 > 350	{ return -ENOSYS; }
   351	
   352	static inline char *kernfs_path(struct kernfs_node *kn, char *buf,
   353					size_t buflen)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--yrj/dFKFPuw6o+aM
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICERsqVcAAy5jb25maWcAjDxbc9s2s+/9FZz2PLQzp7nYjj93zvgBAkEJFUEyBCjJfuEo
MpNoakv+dGmTf392AUq8LZR2JlMLu7jufbHgLz/9ErDjYfuyPKxXy+fn78GXalPtlofqKfi8
fq7+LwjTIElNIEJp3gByvN4cv71dX9/dBjdv7t68+323eh9Mq92meg74dvN5/eUIvdfbzU+/
ADZPk0iOy9ubkTTBeh9stodgXx1+qtsXd7fl9dX999bv5odMtMkLbmSalKHgaSjyBpgWJitM
GaW5Yub+5+r58/XV77iqn08YLOcT6Be5n/c/L3err2+/3d2+XdlV7u0eyqfqs/t97henfBqK
rNRFlqW5aabUhvGpyRkXQ5hSRfPDzqwUy8o8CUvYuS6VTO7vLsHZ4v79LY3AU5Ux88NxOmid
4RIhwlKPy1CxMhbJ2EyatY5FInLJS6kZwoeAyVzI8cT0d8ceygmbiTLjZRTyBprPtVDlgk/G
LAxLFo/TXJqJGo7LWSxHOTMCaBSzh974E6ZLnhVlDrAFBWN8IspYJkAL+SgaDLsoLUyRlZnI
7RgsF6192cM4gYQawa9I5tqUfFIkUw9exsaCRnMrkiORJ8xyapZqLUex6KHoQmcCqOQBz1li
ykkBs2QKaDWBNVMY9vBYbDFNPBrMYblSl2lmpIJjCUGG4IxkMvZhhmJUjO32WAyM35FEkMwy
Zo8P5Vj7uhdZno5ECxzJRSlYHj/A71KJFt3dTHkaMtOiRjY2DE4D2HImYn1/1WBHJ3GUGuT7
7fP609uX7dPxudq//Z8iYUogbwimxds3PQGW+cdynuYtIo0KGYdwJKIUCzefdtJrddTYKrxn
1EvHV2g5dcrTqUhK2IdWWVsrSVOKZAYngYtT0txfn5fNcyCvlUQJJP7550YD1m2lEZpShHD2
LJ6JXAMLdfq1ASUrTEp0tjw/BQ4UcTl+lFlPGmrICCBXNCh+bEt+G7J49PVIfYAbAJyX31pV
e+F9uF3bJQRcIbHz9iqHXdLLI94QAwLfsSIGUUy1QSa7//nXzXZT/daiiH7QM5lxcmxHf+D7
NH8omQGDMSHxoglLwliQsEIL0Iw+Mlv5YwUYY1gHsEZ84mLg+mB//LT/vj9ULw0Xn/U7CIUV
VkL1A0hP0nmLx6EFLCsHBWImoD3DjgbRGcu1QKSmjaPV1GkBfUBTGT4J077OaaN0lUAbMgOz
EKJViBkq2wceEyu2ojxrDqBvWnA8UCiJ0ReBaE1LFv5ZaEPgqRT1G67ldMRm/VLt9tQpTx7R
VMg0lLzNiUmKEOmjtAWTkAmYXNBv2u40120c51ZlxVuz3P8VHGBJwXLzFOwPy8M+WK5W2+Pm
sN58adZmJJ86O8h5WiTG0fI8FdLanmcDHkyX8yLQw10D7kMJsPZw8BOULBwGpeV0D9kwPdXY
hTwEHAp8rjhG5anShEQyuRAW0zpm3nFwSSAzohylqSGxrI0A7ym5okVbTt0fPsEswFt1pgU8
k9CxWXuvfJynRaZptTERfJqlEiw8EN2kOb0RNzIaATsWvVl0pugNxlNQbzNrwPKQXgc/uw4o
/8jT1sFOuifrwe46YiwBgyUT8Np1z1IUMnzfcvNRjE0MFOIisx6UpWSvT8Z1NoUFxczgihqo
47X2QSvQ3xKUaE6fIThOCtiurLUHjfSgI30RYwoA/aBocmY5UHLq4bIx3aW7P7ovODtlVHhW
FBVGLEiIyFLfPuU4YXFEM4NVPR6Y1Z8e2CiLLh/uBOwjCWGSttgsnEnYej0ofeZIcGu6PauC
OUcsz2WXLU7bwTAgFGGf6WDI8mxHrCasA92s2n3e7l6Wm1UViL+rDaheBkqYo/IFE9GoyO4Q
59XUbjcCYeHlTFnvm1z4TLn+pdXOPWPQcS8x+MtpttMxG3kABeVq6DgdtdcLR28grEOzXYIz
KiPJbbTjYf80knHPjrTPNXUYLRk/tZSJko7x2rP/WagM/IGRoBmqDkJoQ4rz2ewDxKLA7ag/
ORda+9YmItibxPOGIKPTo+fOIN3QZoARLEd6zvpetwQtjqE5LM70QNN+1ORac2FIAChZuoNr
xQglonQmnGWvxS7cok7SdNoDYnYAfhs5LtKCcJwgCrKuTO0SEuEphJMP4DSjg2Y1rM3e9GbJ
xViDbQhdNqU+2pJl/aXiaqDVSUoPNpkDowvmLGYPpuQCKNaAtZ2xb4FAWUC7KfIEnDAD7NxO
LfVlnzhICyUGPkl0Xm8vLFSfL+xpNRw9yG04wpWaRQJ80AwzKb0R6lYXGnpgYVp4kgwQupTO
gT+Fm8T6tOCoUSCcj83gaMZg+LO4GMuko9NazT7hAgx7LigTgoOf03GQ+kDa5ejiAPkScXEU
JFMRM9obGGID06Z+zUU4yx4RSzBKEnVSB/MrrVxhGhYxyC1qEBEjHw25QDsICEqqhvmtYQKx
hyAWoPBIOe32uuuSJ80e6l6liTvEbaaFtdExLWYQR4WVZYpyMRAKXBg+nbM8bK03Ba8b/JA6
P3Y9ADCbAO6QGGIZCJ0aTR1FwwhpzNPZ75+W++op+MvZ7Nfd9vP6uRManQ8bscuTDerElI7j
axXoVOREIGFb2SX0yzSa8Pv3LYfDUZk4ihP9begSgyIusvb2Rhg5EN1sKg8mysDgFAkidUPw
Gm6p5+CXYGTfeY4hkqdzG9jt3c0JMpOiCcjVvIeB/P6xEAUmo2ETNuj3o+TzE0Lj4sKBPXYd
OEvrbLddVfv9dhccvr+6cPhztTwcd9W+fQnxiBwYdvNIjYej6HgK86CRYGAqQC8z5XEzLBYm
LE6omOajUcfA15H0yBCOIxYGBAGTz5eCgTo/K3NJT+NiRaAErCnHbKm1hp6gaPIAhgt8bNB/
44JOUILAYejsUroNk9/c3dLu9ocLAKNpVxdhSi0okbm1F0MNJugKCPKUlPRAZ/BlOH20J+gN
DZ16Njb9j6f9jm7neaFTOtBXVrcJj3+t5jLhE7DjnoXU4GtfIBQzz7hjAdH6ePH+ArSM6RhT
8YdcLrznPZOMX5d0htcCPWfHwYn29EI145WMWmF7bhytIGBmor5G0hMZmfsPbZT4fQ/WGT4D
UwGiTqdFEAH1mEWymR1dtBIWCAYB6DbUbtvtTb85nXVblEykKpS1gRG42vFDd93WXeYmVrrj
W8FS0M9G/0bE4OhQBhpGBB1uD6dl/07Nlr6du9oThKmQQAcRYkU+BFjXSAmII6mxCsVde6Oa
MmFcREgSO1SUs5HYWzsN5vi8fyFUZgbe4ql9lsbgzbGczpzVWF5uw0PIJK3TLNG6fOJsViuD
8LLdrA/bnXNNmllbEQicMSjwuecQLMMK8JQeypny6F0vwKTA4iPaKMo7Op2AE+YC7UEkF76k
JjgBwHUgZf5z0f79AP1kSJE2xdx4zwzVTTd0bq2G3t5Qbv1M6SwGI3ndSYo3rRh9ew7UoVzR
kzbgH47wnlqXvXFOwbMV5v7dN/7O/ddTQ4zSP9aRisB3gD2XImHEXbSN//xgqyJOt1jgrbb1
gYyR0+KTO4H3NYW4f3dOHF3qe1qUYklhI9fGWzmvyMGIbdWdu6OVVou7fq1AuxkOojsjW8rW
5QiEGnVd3E5zPWh7QFdLIjWH2KXdvRsf1Q4SqNAotYNQmTVL8szYiaySuull8bg/sTZ5AFUQ
hnlpvBU1M5mDvkwxEuvciWpFIJ9uO21Q6C7Dwvz+5t0ft+0LlmEsS8llu1xi2pFOHguWWGtK
x+Aej/wxS1M64fc4Kmjf5lEPE6knt7sO4Wxxwik556+KiESeY5xiU1hOGPHepL0tq6XQvEMo
neKlf54XWZ92HYWpwcnGiG9+f9siujI5rQbtmlwKwKsmYcP+uMWacnBnaZetzvHQKvOxfP/u
HZUFeSyvPrzrcP5jed1F7Y1CD3MPw/SjlUmOd5X0fYtYCIqsKBKSgz4CQc9RU77vK8pcYJ7M
Xs1d6m9zvdD/qte9TqzPQk3fTXAV2uh45GNW0IEyeijj0FC3Is4X2P5T7QLwBZZfqpdqc7AR
LOOZDLavWEnXiWLrRAmtIGhG0ZEczAliGkS76r/HarP6HuxXy+ee+2E9zFx8JHvKp+eqj+y9
5rZ8jPpBn/HwMiOLRTgYfHTcnzYd/JpxGVSH1ZvfOm4Rp2OMOv1EJU5caVudZG538ETOyAQk
KI09dR/APbSQJcJ8+PCOjqgyjubEL9oPOhoNDkh8q1bHw/LTc2XLMwPrRB72wdtAvByflwN2
GYExUgazifRlnQNrnsuMMicu75cWHc1Xd8LmS4Mq6YnzMarDzLh3PpdBkqlT0e3DHJxHWP29
Bhc63K3/dhdvTUnXelU3B+lQjAp3qTYRceYLLcTMqCzypFcM6GWGOU1fxGCHj2Su5mA7XXUB
iRrNwSKw0LMINGdze21PHVprrXifGOZy5t2MRRCz3JPBAm5rpYHozNWpMgaEGEaSnMxutrGw
VOFUdNQK2ZgrcAzhVKKIyOehEniydO2QTBn6BNOIWIZLdmPl6rlOFZyYumi3oZNrGqxArfcr
aglAAPWAyU9yISLhcaox/YeWvn8+zVHnjNbT/IpcjBBwhirYH19ft7tDezkOUv5xzRe3g26m
+rbcB3KzP+yOL/aKev91uauegsNuudnjUAHo/Cp4gr2uX/HPk/Sw50O1WwZRNmagZHYv/0C3
4Gn7z+Z5u3wKXBXmCVduDtVzAOJqqebk7QTTXEZE8yzNiNZmoMl2f/AC+XL3RE3jxd++nrPD
+rA8VIFq7OyvPNXqt77ywPWdh2vOmk88HsAitlcAXiCLilo0IRT03o3J8FxnprmWNfe1qH42
T1qiU9EJn7DNl9lWjIMjCFF+vYjhXYncvB4PwwkbS5lkxZAtJ0AJyxnybRpgl66bguVw/04u
LWrnJpEpQUoCBwZeroA5Kdk0hs7egKryFZwAaOqDyUzJ0pVpepLm80vOeTLzSXnG7/5zffut
HGeecpdEcz8QVjR2UYc/KWY4/PP4ghAR8P4Fk2OCK07S3lMOpzPaDdOZogETPXRCMxAHYs4s
G/IottUvU7a2BvPUy0FNFqyet6u/+gCxsa4SuPlYU4t+NTgRWByOnr89QrDkKsNilcMWZquC
w9cqWD49rdFjWD67Ufdv2stD2vQqdM+wucfVw9ydjS9jT4rRImCISLtUDs5mniqXubc8ciJy
xejI5FSnS2Up9Kj9UsFppe1mvdoHev28Xm03wWi5+uv1ebnpxAHQjxhtBCH+YLjRDozJavsS
7F+r1fozOGtMjVjHde1lBpxlPj4f1p+PmxXS56Szns4KvNF6UWhdJlolIjCHoF3QzD0x6C1A
YHjt7T4VKvN4dAhW5vb6D8+lBoC18gUFbLT48O7d5aVjHOm7GwKwkSVT19cfFnjPwELPXRsi
Ko+ScSUTxuMHKhFKdkqWDAg03i1fvyKjEIIddi8znbPBs+BXdnxab8FWn29yfxu8JbPI0W75
UgWfjp8/gw0IhzYgoqUSyw5ia3NiHlIrb3KyY4YpQ0/9bVokVE66AGlJJ1yWsTQGglsIzyVr
1dUgfPBiDBvP9QcT3rHnhR4GfthmnbanrreC7dnX73t8vRfEy+9oHIfigLOBxqPtTZpZ+IIL
OSMxEDpm4dijnIo5fexKeXhPKO3N9CQCAiIR0orOlYvJkYSTfiAoIULGT+EjxLRF64WUBTVU
aPw6aCdGykEFgJJv+mOD4u9vbu/e39WQRl4Mvitgml40OGZEuOSiV8UgBiLTPA8Jx/IrT0ql
WIRSZ75S78Ij1zY57PMCZ+sdrIJiHuwmUyBnd9g6Ulrttvvt50Mw+f5a7X6fBV+OFfjvhPSD
YI17VaGdhMep3oEKLhuHegIRjzjjDrdxdkv163pjXYKewHDbqLfHXcdynMaPpzrnpby7+tCq
RYJWMTNE6ygOz60NdYwScZlJWlrAEbeuW8nVDxCUKejL7zOGUfTTCaFqBJAzT1Ag41FK56xk
qlTh1e959bI9VBhUUayijbC3PqrM8c552Pv1Zf+lTxENiL9q+7gkSDfg5a9ff2vcgl50dvYb
9JaTKyiShfTH2DBX6TmTzHJeP+fZnOnCeK2uve6iD9MjitmcupBhwP1j0F2KLcokb5eTyQzr
SXsJzpbBBsfRVu/maewLWCI1pAfahPbLnkGyx2c00H3OFqy8uksU+va0pu9ggRWh2RkcvXKa
Jsxi+GdEF5h7rjsUH1pM4oqdUks5GyoRtnnabddPbTQI9fJU0h5f4o0wtfFEl/ZqxkwGM9uk
S8f3AfoM1myxBl1PqZpwKBUi9GQfTwlK2IDvKikUcVzmI1rThDwcMV+lWzqOxXkKYr0QmTnO
ayng0NXdQIzWKrxv1qsxkJALANFBjVig1gI0d5WbeooTbKEnYvgMUqRtYbgnpXABJh2s9L5A
itiF3h+L1NBpHAvhht41JlojfVN6stUR1iN5YCk4A+BHlEQNLV+uvvb8az24x3Witq+OT1t7
I9EQtJFcsAS+6S2MT2Qc5oJWrvhe15eFx3dadATnHshfhpb9u+zGy7D/Ay7yDIBXG5aH3MMY
GimJh0davx/6CsFz95Gm/ayEzD9GMRvrlp9qe73u1pvDXzZ98fRSgQFtHMazBdIaL6ljFLkZ
qJb6av/+pibl9uUViPO7fS8KVF39tbfDrVz7jnJB3Z0BFjPQkmZrR0oQbfw8R5YLDnGT57mY
Q1WF/X6CIMubXZUqjnb//t3VTVuF5jIrmVal98Ed1jXbGZim1W2RgARg4KxGqecBmSu4mScX
L1AiMn0r8PpGu50NX3lp4T5hAjyjMONCc3IPyR1rmsRUlNM85uiU9vZqpX9U9FvvKLVPtgWb
nqo3PP4iuiXA7d2rj85Q7mH9iWcV+Im77xCkfzp++dIvbcOztnXO2lfr0vswhZ9ksEWdJj41
7oZJR3/C+XpT7/XywQTGcA5DCp4gF2Zwz30K7VMoDmvmS0NbIERZhSdV5zDqqiosRLm8Fbsa
VOxRbJ/1U4s9gX0jWSbDnfvYetK7BquvY4HcQQwR1vHVaZjJcvOlo1bQ6hYZjDJ85dOaAoGg
pxP3SJzOX34kU5gt9kiAZ0GoUvrapQPvF7I5IAZRePk9KFXxakUHduyA33sZqLveMeIMUyEy
6tk9HmMjQMGv+zqi3f9v8HI8VN8q+APrI950KyRq+tRPLC7xEz4Z9sTZDmM+d0j4IHSeMUMr
L4dr/a0Lwpqns8sulx0As28XJjnldmI4sh+sBaaxLwi1iCP/cww7KbDh+dWGx40/ffrpwqRT
p2YuLUt6xq+1nfwRhr6k5U4vGS8RlOcixNcNjPBN8DsMtLq2pPN9pqH+HAh+ZeGSufnhGdsB
sOb5Isa/GuYH34L4WH/36BLj1x9AKXO/TTyddynyPM1BJfwp/LWbrtCSxGlbdUwGn5Q0hN/G
PSa1D/PcUwJKm5OIxAzNw1TPV8ys4o+KhDffYeg//jxDxznLJv8KJ8ostfoPfOunwuTT5S6w
nEszoZ7b1mBl32ICAoegsYdS19y5hboXwf0ns3VHN0oDxB6oQ4iccTRgMCdA+OkV8K9NtT/0
RAgPwAq3/fIUnQVp6IJvP/0MPrIPB71wpyJv/7+PK1ZuEIahv9JPSJoOXcGQ1A0lHJhc6MK1
vQyZesc1Q/6+kkyM7UgewxPEYFuWZb334hwfPx2xQW/lSSwpIgMcW/VurpLi/QrZ7cHQCOlE
MiBJDL4EjfBcGyn9QHjfC6kXQlskpT6UeEbvGvFW71+dZF+Kg+raQLon4J8n2lWIeisQOsnr
SfbR8ORQL/baFcEhA/5OuY0+77IangzRISqyWBbrsgNCNO11jlS73tmaszIsMLE+JlFKgQl8
iCjzQ2fr4AV5Glt+nRBIoYMAg6NSPgNdbBIe3CrNydNk9vP8mLX0efLZqdityrdVL9GhbRYd
5qosNoEnKoIr1geriziaoSnH1el1tcSmMQZ9teYxOzwXWb0QJTbU5gGjP/MLZRdA2N87i8R0
cDZ1VDTpPum8RPpN9ANv1WSPs3HGnA6Rp3cYdRZEPUKK3vHmYKXiV/qmR9E/dKyPLbAnGOef
63T5u3FplH05CNmrUvWtNgP4mrKjHD7NsqQtm4C4f7rlgZlHeYnRUJawHZqEpuAxIHLMO1T9
KWu/5LrO2oFx93ZDc/mevqbb0/R7hQXy7OWvnMiIaWsFMcwW6xoxXmF0SMCkKmsB3er6LuiZ
a0bWrVHaFRZHkHiZUWcgsjcpTTWVDtVqVKtGpbThOxLQNU/Ew/vMelVofplEWBuIbSV0wx+u
AMLXoVQ6p7skJUPF85ZJe3BW9LPcCIZsuwQrVCG3eU4HI6dPFPhNQGOu3tlB2mGv+awwewl9
acjgoiXOV7l0XeniJfwfvaXzBaOPoaoIxIfCGxYFv98hwUVReGsmgklgTH2K29zhQXima+Z1
cE0ZaVkC8B+y2tbf3lkAAA==

--yrj/dFKFPuw6o+aM--
