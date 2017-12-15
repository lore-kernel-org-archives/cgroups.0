From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Fri, 15 Dec 2017 14:24:55 +0530
Message-ID: <c282b638-95ef-b688-9249-f23a733c0a43@codeaurora.org>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <4e63b5e9-1696-910f-16ac-4d4d7eb98725@codeaurora.org>
 <40968aea-cd73-5ce4-d559-962d91e315c5@codeaurora.org>
 <20171211153258.GI2421075@devbig577.frc2.facebook.com>
 <c54d904e-13bc-8e2b-c9c1-8bf9cb8a33a3@codeaurora.org>
 <20171213154041.GP3919388@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513328111;
        bh=Y8DE8wfJ2RLOzxK5NU9szWzTOs2YDzC7STMhflzaIX8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aKkqZwpOiM85KshdKiJFYiboaIGJUxWBvonNjUOD+y9Gjj4nMiJ/+U+qXGplN8IqC
         Rof/dcL2lDJLKvuUfoSVD5roer1Hx2kTfVQ2SsSqimPrHlhN/B2bFMyjtfg/5uJPK+
         tXvVOUKl6vBX+vJbGwPmTiJAllYx+rdU78wf9/ag=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1513328108;
        bh=Y8DE8wfJ2RLOzxK5NU9szWzTOs2YDzC7STMhflzaIX8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YOoJMMINrkY0HtIb3Rucxavc/UGcAAs9PHXwHbF/IAWP4l3oqG+QhgeLqxRO8iQW3
         wAm9shJpMTkRVG0A8csVXUlrGWOjZ/K0dU/4ZjcNtbfLlWuY3K2VI1IUTYzh8pAMfb
         XQYKEe71Fv4S5zuZQWNHVVwOyGtde8dKmeWTOnfM=
In-Reply-To: <20171213154041.GP3919388-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On 12/13/2017 09:10 PM, Tejun Heo wrote:
Hi TJ,

> Hello, Prateek.
> 
> On Wed, Dec 13, 2017 at 07:58:24PM +0530, Prateek Sood wrote:
>> Did you mean something like below. If not then could you
>> please share a patch for this problem in
>> cgroup_transfer_tasks().
> 
> Oh we surely can add a new iterator but we can just count in
> cgroup_transfer_tasks() too, right?
I did not get what you meant by this. Could you please share a
patch for this.
> 
> Thanks.
> 

Following are two ways to improve cgroup_transfer_tasks(). In
both cases task in PF_EXITING state would be left in source
cgroup. It would be removed from cgroup_exit() in exit path.

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 024085d..e2bdcdb 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -123,7 +123,10 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
         */
        do {
                css_task_iter_start(&from->self, 0, &it);
-               task = css_task_iter_next(&it);
+               do {
+                       task = css_task_iter_next(&it);
+               } while (task && (task & PF_EXITING))
+
                if (task)
                        get_task_struct(task);
                css_task_iter_end(&it);

----------------------------8<---------------------------------

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 024085d..843b8bb 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -121,12 +121,11 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
         * Migrate tasks one-by-one until @from is empty.  This fails iff
         * ->can_attach() fails.
         */
+       css_task_iter_start(&from->self, 0, &it);
        do {
-               css_task_iter_start(&from->self, 0, &it);
                task = css_task_iter_next(&it);
                if (task)
                        get_task_struct(task);
-               css_task_iter_end(&it);

                if (task) {
                        ret = cgroup_migrate(task, false, &mgctx);
@@ -135,6 +134,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
                        put_task_struct(task);
                }
        } while (task && !ret);
+       css_task_iter_end(&it);
 out_err:
        cgroup_migrate_finish(&mgctx);
        percpu_up_write(&cgroup_threadgroup_rwsem);


Thanks


-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
