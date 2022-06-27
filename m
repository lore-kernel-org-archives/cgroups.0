From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Question] The system may be stuck if there is a cpu cgroup
 cpu.cfs_quato_us is very low
Date: Mon, 27 Jun 2022 17:32:06 +0900
Message-ID: <YrlrBmF3oOfS3+fq@mtj.duckdns.org>
References: <5987be34-b527-4ff5-a17d-5f6f0dc94d6d@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=szaOjwym60f/8LOXYqQ6hITRb/YVPZeOicD4V048pqo=;
        b=NJafOd4qjIKqtOlocUHdmBBRJMZTiIDE9Gy+KP+BfbC2M2gFw1riyA4lEBuE/dAWix
         WhPNkbovuagZbKm0nCuWosFUIsHnS9h/OpK2eCNetrkuNknRM/DvtwyF/voZgdmOMYBV
         wVmEcUjC2IzelVFnbDfH6uj/hrEK2lANiE7wxTkS+2R/C801GBOeMZttPJXx24mKNx+h
         domxFmIBXvWRVrN+OlIQgm+jRLZn1quwrObi1sECH07N1mCqNXEQ1QoKgHQ4NoC4CKnG
         ZDEAQp69z2lDMPLiVFfvnL6g/xd6NjDKSB7WJE1xfF3WqXeJjCeNUIZTF+aSdhdG5b7Y
         QLBQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5987be34-b527-4ff5-a17d-5f6f0dc94d6d-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, mgorman-l3A5Bk7waGM@public.gmane.org

Hello,

On Mon, Jun 27, 2022 at 02:50:25PM +0800, Zhang Qiao wrote:
> Becuase the task cgroup's cpu.cfs_quota_us is very small and
> test_fork's load is very heavy, the test_fork may be throttled long
> time, therefore, the cgroup_threadgroup_rw_sem read lock is held for
> a long time, other processes will get stuck waiting for the lock:

Yeah, this is a known problem and can happen with other locks too. The
solution prolly is only throttling while in or when about to return to
userspace. There is one really important and wide-spread assumption in
the kernel:

  If things get blocked on some shared resource, whatever is holding
  the resource ends up using more of the system to exit the critical
  section faster and thus unblocks others ASAP. IOW, things running in
  kernel are work-conserving.

The cpu bw controller gives the userspace a rather easy way to break
this assumption and thus is rather fundamentally broken. This is
basically the same problem we had with the old cgroup freezer
implementation which trapped threads in random locations in the
kernel.

So, right now, it's rather broken and can easily be used as an dos
attack vector.

Thanks.

-- 
tejun
