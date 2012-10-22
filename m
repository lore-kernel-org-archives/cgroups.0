From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.7-fixes 1/2] Revert "cgroup: Remove
 task_lock() from cgroup_post_fork()"
Date: Mon, 22 Oct 2012 11:30:18 +0200
Message-ID: <CAFTL4hyW+WUUye2BTf5V+Qp_nDVjUnedutoOe-wbU1hT5wgHig@mail.gmail.com>
References: <20121008020000.GB2575@localhost>
	<20121019005922.GG13370@google.com>
	<CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg@mail.gmail.com>
	<20121019193808.GL13370@google.com>
	<CAFTL4hwQ6Ntn5GJwj=jiO2p3GdwhEMp0MyR8dgUj_Lx0U4kNqg@mail.gmail.com>
	<20121019210738.GA1180@google.com>
	<CAFTL4hy+vrvJKrc1Y2FW44k=LBi72H=34337xALpbtG_3u5O7w@mail.gmail.com>
	<20121020223709.GA5626@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=TLKaMr3hRM+rBvWztLyFHGPuZbNf9gMUH4D1gKdZ3UQ=;
        b=hwSEMSepB1gvgCdfpkZhBAVa971N3Tr4uY88CR9Oh147UWdeXJn8F/u8TTYAa741ZJ
         rqyEofvM9Vvmi3Pu1IhHCaPLS6sAve3EGK88bx4scn0gSoGoPQqevFoPy5SJF/YDXJ3x
         wRzwrrjKo05BKGXP3zDuMBI+0QbX6Dto7Y3JM4O58YarVz9OcmAaKVpNyVxzR/PQngll
         fgzdFfw9e0Xl6xXQRNLNyGx310nWxGd0Iyi0AiT9+lS6/7ohpo2Io7EVzxEU+It5TllZ
         DK5jAd2v9ZIqObdDfyGMeeusP5rkHYm40xxuPPKvkiCBEhMuQmsclbHiS8BJBKr8FuwU
         yqVA==
In-Reply-To: <20121020223709.GA5626-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2012/10/21 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> Hello, Frederic.
>
> On Sat, Oct 20, 2012 at 02:21:43PM -0400, Frederic Weisbecker wrote:
>> CPU 0
>>                     CPU 1
>>
>> cgroup_task_migrate {
>>         task_lock(p)
>>         rcu_assign_pointer(tsk->cgroups, newcg);
>>         task_unlock(tsk);
>>
>>         write_lock(&css_set_lock);
>>         if (!list_empty(&tsk->cg_list))
>>             list_move(&tsk->cg_list, &newcg->tasks);
>>         write_unlock(&css_set_lock);
>>
>>                           write_lock(&css_set_lock);
>>       put_css_set(oldcg);
>>          list_add(&child->cg_list, &child->cgroups->tasks); (1)
>
> Man, that's confusing. :)

Sorry and I'm currently stuck in some airport and too lazy to reorder
the above lines :)

>
>> On (1), child->cgroups should have the value of newcg and not oldcg
>> due to the memory ordering implied by the locking of css_set_lock. Now
>> I can't guarantee that because I'm no memory ordering expert. And even
>> if it's safe, it's so very non obvious that I now agree with you:
>> let's revert  the patch and restart with a better base by gathering
>> all the cgroup fork code in the current cgroup_post_fork place.
>
> Aye aye, let's move everything to cgroup_post_fork() and then we don't
> have to worry about grabbing task_lock multiple times.

Agreed. and Acked-by: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
