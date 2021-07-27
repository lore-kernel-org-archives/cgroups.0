From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-5.14-fixes] cgroup: rstat: fix A-A deadlock on
 32bit around u64_stats_sync
Date: Tue, 27 Jul 2021 13:13:21 -1000
Message-ID: <YQCTEYhcxKccOamq@slm.duckdns.org>
References: <YQCREXMBq1EPoQWu@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IJH4q6xKknpFCnME1MQ4rrc80QVCXZj1Kd8DIZ0/IhQ=;
        b=RDDPk3g21uOn+gvEHvobhce6lQTn5Mq7nQNxDeFycx7c7RXn4xjZnyH/omdaeMk+O3
         bFAWs+7yxxqhCqLCMsJ9sgGr14Zxo6uVYqApMj6C2S+6L0Bw7EBgdo1njMLa8WAV8j9J
         Ydz92yY4SQZTpCctVQbhovhNiiHXHyRauzBeaWX0GqXod0tb7Hdi6/G0wflkCGXrHI55
         7IpHNYSWY2V4emWWdKAT8srhjlCD2DbZUZKyDpHDOxKfYjQLd/nXsOKBJ8Qq2NvtGlT6
         kmNTnk0xrhQsqfyd8Hho/kLvsqw+ahDCLptTC8ne7eLn7FTy7xsE1rioaqbOe64k++oF
         Ku2Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YQCREXMBq1EPoQWu-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>

On Tue, Jul 27, 2021 at 01:04:49PM -1000, Tejun Heo wrote:
> 0fa294fb1985 ("cgroup: Replace cgroup_rstat_mutex with a spinlock") added
> cgroup_rstat_flush_irqsafe() allowing flushing to happen from the irq
> context. However, rstat paths use u64_stats_sync to synchronize access to
> 64bit stat counters on 32bit machines. u64_stats_sync is implemented using
> seq_lock and trying to read from an irq context can lead to A-A deadlock if
> the irq happens to interrupt the stat update.
> 
> Fix it by using the irqsafe variants - u64_stats_update_begin_irqsave() and
> u64_stats_update_end_irqrestore() - in the update paths. Note that none of
> this matters on 64bit machines. All these are just for 32bit SMP setups.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>

Applying this to cgroup/for-5.14-fixes with stable tag added.

Thanks.

-- 
tejun
