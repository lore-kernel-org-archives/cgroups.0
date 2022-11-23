From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Wed, 23 Nov 2022 15:23:55 -0500
Message-ID: <2ac6f207-e08a-2a7f-01ae-dfaf15eefaf6@redhat.com>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------UyHPKBK8yiP03gC4izCN5JwL"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669235042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W6/q0I9lhD2Ic91IJouqxj39nsjVclbcOMvuo2nvzhI=;
        b=PkjOCtxJID0YwIHCsr2Eh8P2ckyXjsfEhDPis4sls6u20J0iO+REDf8g/ulfGN/VvkX3+9
        B+uIjxqrZS4T8s/xWiER2Wumd8iAI27dOkINEcfBkH5uaf96ObA1asrKgUgF6Rbu1/naVG
        d23Ug0ggqwWOjDa2AWrMT3fUdpGZsrs=
Content-Language: en-US
In-Reply-To: <20221123082157.71326-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------UyHPKBK8yiP03gC4izCN5JwL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/22 03:21, haifeng.xu wrote:
> When change the 'cpuset.mems' under some cgroup, system will hung
> for a long time. From the dmesg, many processes or theads are
> stuck in fork/exit. The reason is show as follows.
>
> thread A:
> cpuset_write_resmask /* takes cpuset_rwsem */
>    ...
>      update_tasks_nodemask
>        mpol_rebind_mm /* waits mmap_lock */
>
> thread B:
> worker_thread
>    ...
>      cpuset_migrate_mm_workfn
>        do_migrate_pages /* takes mmap_lock */
>
> thread C:
> cgroup_procs_write /* takes cgroup_mutex and cgroup_threadgroup_rwsem */
>    ...
>      cpuset_can_attach
>        percpu_down_write /* waits cpuset_rwsem */
>
> Once update the nodemasks of cpuset, thread A wakes up thread B to
> migrate mm. But when thread A iterates through all tasks, including
> child threads and group leader, it has to wait the mmap_lock which
> has been take by thread B. Unfortunately, thread C wants to migrate
> tasks into cgroup at this moment, it must wait thread A to release
> cpuset_rwsem. If thread B spends much time to migrate mm, the
> fork/exit which acquire cgroup_threadgroup_rwsem also need to
> wait for a long time.
>
> There is no need to migrate the mm of child threads which is
> shared with group leader. Just iterate through the group
> leader only.
>
> Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 589827ccda8b..43cbd09546d0 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1968,6 +1968,9 @@ static void update_tasks_nodemask(struct cpuset *cs)
>   
>   		cpuset_change_task_nodemask(task, &newmems);
>   
> +		if (!thread_group_leader(task))
> +			continue;
> +
>   		mm = get_task_mm(task);
>   		if (!mm)
>   			continue;

Could you try the attached test patch to see if it can fix your problem? 
Something along the line of this patch will be more acceptable.

Thanks,
Longman


--------------UyHPKBK8yiP03gC4izCN5JwL
Content-Type: text/x-patch; charset=UTF-8; name="test.patch"
Content-Disposition: attachment; filename="test.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2tlcm5lbC9jZ3JvdXAvY3B1c2V0LmMgYi9rZXJuZWwvY2dyb3VwL2Nw
dXNldC5jCmluZGV4IGI0NzQyODljMTViOC4uOWMxN2I2ZDQ4NzdjIDEwMDY0NAotLS0gYS9r
ZXJuZWwvY2dyb3VwL2NwdXNldC5jCisrKyBiL2tlcm5lbC9jZ3JvdXAvY3B1c2V0LmMKQEAg
LTE5NDIsNiArMTk0Miw3IEBAIHN0YXRpYyB2b2lkIHVwZGF0ZV90YXNrc19ub2RlbWFzayhz
dHJ1Y3QgY3B1c2V0ICpjcykKIAlzdGF0aWMgbm9kZW1hc2tfdCBuZXdtZW1zOwkvKiBwcm90
ZWN0ZWQgYnkgY3B1c2V0X3J3c2VtICovCiAJc3RydWN0IGNzc190YXNrX2l0ZXIgaXQ7CiAJ
c3RydWN0IHRhc2tfc3RydWN0ICp0YXNrOworCWJvb2wgbWlncmF0ZTsKIAogCWNwdXNldF9i
ZWluZ19yZWJvdW5kID0gY3M7CQkvKiBjYXVzZXMgbXBvbF9kdXAoKSByZWJpbmQgKi8KIApA
QCAtMTk1NywxOSArMTk1OCwyNSBAQCBzdGF0aWMgdm9pZCB1cGRhdGVfdGFza3Nfbm9kZW1h
c2soc3RydWN0IGNwdXNldCAqY3MpCiAJICogSXQncyBvayBpZiB3ZSByZWJpbmQgdGhlIHNh
bWUgbW0gdHdpY2U7IG1wb2xfcmViaW5kX21tKCkKIAkgKiBpcyBpZGVtcG90ZW50LiAgQWxz
byBtaWdyYXRlIHBhZ2VzIGluIGVhY2ggbW0gdG8gbmV3IG5vZGVzLgogCSAqLworCW1pZ3Jh
dGUgPSBpc19tZW1vcnlfbWlncmF0ZShjcyk7CiAJY3NzX3Rhc2tfaXRlcl9zdGFydCgmY3Mt
PmNzcywgMCwgJml0KTsKIAl3aGlsZSAoKHRhc2sgPSBjc3NfdGFza19pdGVyX25leHQoJml0
KSkpIHsKIAkJc3RydWN0IG1tX3N0cnVjdCAqbW07Ci0JCWJvb2wgbWlncmF0ZTsKIAogCQlj
cHVzZXRfY2hhbmdlX3Rhc2tfbm9kZW1hc2sodGFzaywgJm5ld21lbXMpOwogCisJCS8qCisJ
CSAqIFNraXAgbW0gdXBkYXRlIGlmIGEgbm9uIGdyb3VwIGxlYWRlciB0YXNrIGFuZCBpdHMg
Z3JvdXAKKwkJICogbGVhZGVyIGFyZSBpbiB0aGUgc2FtZSBjcHVzZXQuCisJCSAqLworCQlp
ZiAoIXRocmVhZF9ncm91cF9sZWFkZXIodGFzaykgJiYKKwkJICAgKHRhc2tfY3ModGFzay0+
Z3JvdXBfbGVhZGVyKSA9PSBjcykpCisJCQljb250aW51ZTsKKwogCQltbSA9IGdldF90YXNr
X21tKHRhc2spOwogCQlpZiAoIW1tKQogCQkJY29udGludWU7CiAKLQkJbWlncmF0ZSA9IGlz
X21lbW9yeV9taWdyYXRlKGNzKTsKLQogCQltcG9sX3JlYmluZF9tbShtbSwgJmNzLT5tZW1z
X2FsbG93ZWQpOwogCQlpZiAobWlncmF0ZSkKIAkJCWNwdXNldF9taWdyYXRlX21tKG1tLCAm
Y3MtPm9sZF9tZW1zX2FsbG93ZWQsICZuZXdtZW1zKTsK

--------------UyHPKBK8yiP03gC4izCN5JwL--

