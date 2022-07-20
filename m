From: Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Query regarding deadlock involving cgroup_threadgroup_rwsem and
 cpu_hotplug_lock
Date: Wed, 20 Jul 2022 13:27:28 +1000
Message-ID: <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
References: <8245b710-8acb-d8e6-7045-99a5f71dad4e@oracle.com>
 <26d0e4cc-be0e-2c12-6174-dfbb1edb1ed6@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=4YBNVusGpdz5SOEFgMufVD6zRMtqYM3KOMIqUWpMezs=;
 b=VpCPbJ2qrcYudrNeddVS03dNwZQ0z187TlYeN6Fnblc66xEu8SvYHgNNV712r33PQoLD
 Sg+YREDqQamy1h9Af6cU21u7qQdRceY6Qb5TgTdP/2STnHbumXbL/e8F3IQqzt8RSY0E
 ZFxd0hRh+0U8L76tZ0gLUUconqdNMou2P3of8GmCf5pw28Y05VWjuPeHF41u6oBMvmia
 NufXSyIpWZk7XDy1czBU0wLS+oqoiFj0FR7U8ZbBvZiFQRHDqdkhiSQA6prodotNm27A
 EVV0M5W/D6A4FJWLqZealfkIMTeulqKGD1qXPQJuGBVeBNCOS/t428rbyLOMGVVX6dv/ KQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4YBNVusGpdz5SOEFgMufVD6zRMtqYM3KOMIqUWpMezs=;
 b=He2Bg/Wm09aHwihLBcCFUcENiwhBfJMhUK7EQwDB+PGBb0JNhquWkXrCrpgkRkkNQGhLcLgoGfWImLrg5ixINlz5LuAtv1Bi7XWInkMp4MrfPXsx0cnPwvJqkQJW5dAGuOurQjIecteFPQj22AioQYvOljc30466hz3Y04/JyRc=
Content-Language: en-US
In-Reply-To: <26d0e4cc-be0e-2c12-6174-dfbb1edb1ed6-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello everyone,

I am seeing a deadlock between cgroup_threadgroup_rwsem and cpu_hotplug_lock in
5.4 kernel.

Due to some missing drivers I don't have this test setup for latest upstream
kernel but looking at the code the issue seems to be present in the latest
kernel as well. If needed I can provide stack traces and other relevant info
from the vmcore that I have got from 5.4 setup.

The description of the problem is as follows (I am using 5.19-rc7 as reference
below):

__cgroup_procs_write acquires cgroup_threadgroup_rwsem via
cgroup_procs_write_start and then invokes cgroup_attach_task. Now
cgroup_attach_task can invoke following call chain:

cgroup_attach_task --> cgroup_migrate --> cgroup_migrate_execute --> cpuset_attach

Here cpuset_attach tries to take cpu_hotplug_lock.

But by this time if some other context

1. is already in the middle of cpu hotplug and has acquired cpu_hotplug_lock in
_cpu_up but
2. has not yet reached CPUHP_ONLINE state and
3. one of the intermediate hotplug states (in my case CPUHP_AP_ONLINE_DYN ) has
a callback which involves creation of a thread (or invocation of copy_process
via some other path) the invoked copy_process will get blocked on
cgroup_threadgroup_rwsem in following call chain:

   copy_process --> cgroup_can_fork --> cgroup_css_set_fork -->
cgroup_threadgroup_change_begin


I am looking for suggestions to fix this deadlock.

Or if I am missing something in the above analysis and the above mention
scenario can't happen in latest upstream kernel, then please let me know as that
would help me in back porting relevant changes to 5.4 kernel because the issue
definitely exists in 5.4 kernel.

Thanks,
-- Imran
