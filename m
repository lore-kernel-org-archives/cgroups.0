From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Wed, 26 Aug 2020 16:59:28 +0800
Message-ID: <01ed6e45-3853-dcba-61cb-b429a49a7572@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
 <ec62a835-f79d-2b8c-99c7-120834703b42@linux.alibaba.com>
 <20200826011946.spknwjt44d2szrdo@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------7C4509CD50BDF422F0129A10"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200826011946.spknwjt44d2szrdo-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This is a multi-part message in MIME format.
--------------7C4509CD50BDF422F0129A10
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit



在 2020/8/26 上午9:19, Daniel Jordan 写道:
> On Tue, Aug 25, 2020 at 11:26:58AM +0800, Alex Shi wrote:
>> 在 2020/8/25 上午9:56, Daniel Jordan 写道:
>>> Alex, do you have a pointer to the modified readtwice case?
>>
>> Sorry, no. my developer machine crashed, so I lost case my container and modified
>> case. I am struggling to get my container back from a account problematic repository. 
>>
>> But some testing scripts is here, generally, the original readtwice case will
>> run each of threads on each of cpus. The new case will run one container on each cpus,
>> and just run one readtwice thead in each of containers.
> 
> Ok, what you've sent so far gives me an idea of what you did.  My readtwice
> changes were similar, except I used the cgroup interface directly instead of
> docker and shared a filesystem between all the cgroups whereas it looks like
> you had one per memcg.  30 second runs on 5.9-rc2 and v18 gave 11% more data
> read with v18.  This was using 16 cgroups (32 dd tasks) on a 40 CPU, 2 socket
> machine.

I clean up my testing and make it reproducable by a Dockerfile and a case patch which
attached. 
User can build a container from the file, and then do testing like following:

#start some testing containers
for ((i=0; i< 80; i++)); do docker run --privileged=true --rm lrulock bash -c " sleep 20000" & done

#do testing evn setup 
for i in `docker ps | sed '1 d' | awk '{print $1 }'` ;do docker exec --privileged=true -it $i bash -c "cd vm-scalability/; bash -x ./case-lru-file-readtwice m"& done

#kick testing
for i in `docker ps | sed '1 d' | awk '{print $1 }'` ;do docker exec --privileged=true -it $i bash -c "cd vm-scalability/; bash -x ./case-lru-file-readtwice r"& done

#show result
for i in `docker ps | sed '1 d' | awk '{print $1 }'` ;do echo === $i ===; docker exec $i bash -c 'cat /tmp/vm-scalability-tmp/dd-output-* '  & done | grep MB | awk 'BEGIN {a=0;} { a+=$10 } END {print NR, a/(NR)}'

This time, on a 2P * 20 core * 2 HT machine,
This readtwice performance is 252% compare to v5.9-rc2 kernel. A good surprise!

> 
>>> Even better would be a description of the problem you're having in production
>>> with lru_lock.  We might be able to create at least a simulation of it to show
>>> what the expected improvement of your real workload is.
>>
>> we are using thousands memcgs in a machine, but as a simulation, I guess above case
>> could be helpful to show the problem.
> 
> Using thousands of memcgs to do what?  Any particulars about the type of
> workload?  Surely it's more complicated than page cache reads :)

Yes, the workload are quit different on different business, some use cpu a lot, some use
memory a lot, and some are may mixed. For containers number, that are also quit various
from tens to hundreds to thousands.

> 
>>> I ran a few benchmarks on v17 last week (sysbench oltp readonly, kerndevel from
>>> mmtests, a memcg-ized version of the readtwice case I cooked up) and then today
>>> discovered there's a chance I wasn't running the right kernels, so I'm redoing
>>> them on v18.
> 
> Neither kernel compile nor git checkout in the root cgroup changed much, just
> 0.31% slower on elapsed time for the compile, so no significant regressions
> there.  Now for sysbench again.
> 

Thanks a lot for testing report!
Alex

--------------7C4509CD50BDF422F0129A10
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="Dockerfile"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Dockerfile"

RlJPTSBjZW50b3M6OApNQUlOVEFJTkVSIEFsZXhzIAojV09SS0RJUiAvdm0tc2NhbGFiaWxp
dHkgCiNSVU4geXVtIHVwZGF0ZSAteSAmJiB5dW0gZ3JvdXBpbnN0YWxsICJEZXZlbG9wbWVu
dCBUb29scyIgLXkgJiYgeXVtIGNsZWFuIGFsbCAmJiBcCiNleGFtcGxlcyBodHRwczovL3d3
dy5saW51eHRlY2hpLmNvbS9idWlsZC1kb2NrZXItY29udGFpbmVyLWltYWdlcy13aXRoLWRv
Y2tlcmZpbGUvClJVTiB5dW0gaW5zdGFsbCBnaXQgeGZzcHJvZ3MgcGF0Y2ggbWFrZSBnY2Mg
LXkgJiYgeXVtIGNsZWFuIGFsbCAmJiBcCmdpdCBjbG9uZSAgaHR0cHM6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvd2ZnL3ZtLXNjYWxhYmlsaXR5LmdpdC8g
JiYgXApjZCB2bS1zY2FsYWJpbGl0eSAmJiBtYWtlIHVzZW1lbQoKQ09QWSByZWFkdHdpY2Uu
cGF0Y2ggL3ZtLXNjYWxhYmlsaXR5LwoKUlVOIGNkIHZtLXNjYWxhYmlsaXR5ICYmIHBhdGNo
IC1wMSA8IHJlYWR0d2ljZS5wYXRjaAo=
--------------7C4509CD50BDF422F0129A10
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="readtwice.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="readtwice.patch"

ZGlmZiAtLWdpdCBhL2Nhc2UtbHJ1LWZpbGUtcmVhZHR3aWNlIGIvY2FzZS1scnUtZmlsZS1y
ZWFkdHdpY2UKaW5kZXggODU1MzNiMjQ4NjM0Li41N2NiOTdkMTIxYWUgMTAwNzU1Ci0tLSBh
L2Nhc2UtbHJ1LWZpbGUtcmVhZHR3aWNlCisrKyBiL2Nhc2UtbHJ1LWZpbGUtcmVhZHR3aWNl
CkBAIC0xNSwyMyArMTUsMzAgQEAKIAogLiAuL2h3X3ZhcnMKIAotZm9yIGkgaW4gYHNlcSAx
ICRucl90YXNrYAotZG8KLQljcmVhdGVfc3BhcnNlX2ZpbGUgJFNQQVJTRV9GSUxFLSRpICQo
KFJPVEFURV9CWVRFUyAvIG5yX3Rhc2spKQotCXRpbWVvdXQgLS1mb3JlZ3JvdW5kIC1zIElO
VCAke3J1bnRpbWU6LTYwMH0gZGQgYnM9NGsgaWY9JFNQQVJTRV9GSUxFLSRpIG9mPS9kZXYv
bnVsbCA+ICRUTVBGU19NTlQvZGQtb3V0cHV0LTEtJGkgMj4mMSAmCi0JdGltZW91dCAtLWZv
cmVncm91bmQgLXMgSU5UICR7cnVudGltZTotNjAwfSBkZCBicz00ayBpZj0kU1BBUlNFX0ZJ
TEUtJGkgb2Y9L2Rldi9udWxsID4gJFRNUEZTX01OVC9kZC1vdXRwdXQtMi0kaSAyPiYxICYK
LWRvbmUKK09VVF9ESVI9JChob3N0bmFtZSktJHtucl90YXNrfWMtJCgoKG1lbSArICgxPDwy
OSkpPj4zMCkpZworVEVTVF9DQVNFUz0ke0A6LSQoZWNobyBjYXNlLSopfQorCitlY2hvICQo
KDE8PDMwKSkgPiAvcHJvYy9zeXMvdm0vbWF4X21hcF9jb3VudAorZWNobyAkKCgxPDwyMCkp
ID4gL3Byb2Mvc3lzL2tlcm5lbC90aHJlYWRzLW1heAorZWNobyAxID4gL3Byb2Mvc3lzL3Zt
L292ZXJjb21taXRfbWVtb3J5CisjZWNobyAzID4gL3Byb2Mvc3lzL3ZtL2Ryb3BfY2FjaGVz
CisKKworaT0xCisKK2lmIFsgIiQxIiA9PSAibSIgXTt0aGVuCisJbW91bnRfdG1wZnMKKwlj
cmVhdGVfc3BhcnNlX3Jvb3QKKwljcmVhdGVfc3BhcnNlX2ZpbGUgJFNQQVJTRV9GSUxFLSRp
ICQoKFJPVEFURV9CWVRFUykpCisJZXhpdAorZmkKKworCitpZiBbICIkMSIgPT0gInIiIF07
dGhlbgorCSh0aW1lb3V0IC0tZm9yZWdyb3VuZCAtcyBJTlQgJHtydW50aW1lOi0zMDB9IGRk
IGJzPTRrIGlmPSRTUEFSU0VfRklMRS0kaSBvZj0vZGV2L251bGwgPiAkVE1QRlNfTU5UL2Rk
LW91dHB1dC0xLSRpIDI+JjEpJgorCSh0aW1lb3V0IC0tZm9yZWdyb3VuZCAtcyBJTlQgJHty
dW50aW1lOi0zMDB9IGRkIGJzPTRrIGlmPSRTUEFSU0VfRklMRS0kaSBvZj0vZGV2L251bGwg
PiAkVE1QRlNfTU5UL2RkLW91dHB1dC0yLSRpIDI+JjEpJgorZmkKIAogd2FpdAogc2xlZXAg
MQogCi1mb3IgZmlsZSBpbiAkVE1QRlNfTU5UL2RkLW91dHB1dC0qCi1kbwotCVsgLXMgIiRm
aWxlIiBdIHx8IHsKLQkJZWNobyAiZGQgb3V0cHV0IGZpbGUgZW1wdHk6ICRmaWxlIiA+JjIK
LQl9Ci0JY2F0ICRmaWxlCi0Jcm0gICRmaWxlCi1kb25lCi0KLXJtIGBzZXEgLWYgJFNQQVJT
RV9GSUxFLSVnIDEgJG5yX3Rhc2tgCmRpZmYgLS1naXQgYS9od192YXJzIGIvaHdfdmFycwpp
bmRleCA4NzMxY2VmYjlmNTcuLmNlZWFhOWYxN2MwYiAxMDA3NTUKLS0tIGEvaHdfdmFycwor
KysgYi9od192YXJzCkBAIC0xLDQgKzEsNCBAQAotIyEvYmluL3NoCisjIS9iaW4vc2ggLWV4
CiAKIGlmIFsgLW4gIiRydW50aW1lIiBdOyB0aGVuCiAJVVNFTUVNPSIkQ01EIC4vdXNlbWVt
IC0tcnVudGltZSAkcnVudGltZSIKQEAgLTQzLDcgKzQzLDcgQEAgY3JlYXRlX2xvb3BfZGV2
aWNlcygpCiAJbW9kcHJvYmUgbG9vcCAyPi9kZXYvbnVsbAogCVsgLWUgIi9kZXYvbG9vcDAi
IF0gfHwgbW9kcHJvYmUgbG9vcCAyPi9kZXYvbnVsbAogCi0JZm9yIGkgaW4gJChzZXEgMCA4
KQorCWZvciBpIGluICQoc2VxIDAgMTA0KQogCWRvCiAJCVsgLWUgIi9kZXYvbG9vcCRpIiBd
ICYmIGNvbnRpbnVlCiAJCW1rbm9kIC9kZXYvbG9vcCRpIGIgNyAkaQpAQCAtMTAxLDExICsx
MDEsMTEgQEAgcmVtb3ZlX3NwYXJzZV9yb290ICgpIHsKIGNyZWF0ZV9zcGFyc2VfZmlsZSAo
KSB7CiAJbmFtZT0kMQogCXNpemU9JDIKLQkjIGVjaG8gIiRuYW1lIGlzIG9mIHNpemUgJHNp
emUiCisJZWNobyAiJG5hbWUgaXMgb2Ygc2l6ZSAkc2l6ZSIKIAkkQ01EIHRydW5jYXRlICRu
YW1lIC1zICRzaXplCiAJIyBkZCBpZj0vZGV2L3plcm8gb2Y9JG5hbWUgYnM9MWsgY291bnQ9
MSBzZWVrPSQoKHNpemUgPj4gMTApKSAyPi9kZXYvbnVsbAotCSMgbHMgJFNQQVJTRV9ST09U
Ci0JIyBscyAvdG1wL3ZtLXNjYWxhYmlsaXR5LyoKKwlscyAkU1BBUlNFX1JPT1QKKwlscyAv
dG1wL3ZtLXNjYWxhYmlsaXR5LyoKIH0KIAogCgo=
--------------7C4509CD50BDF422F0129A10--
