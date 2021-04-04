From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/1] Introduce new attribute "priority" to control group
Date: Sun, 4 Apr 2021 13:29:44 -0400
Message-ID: <YGn3iHBp5UweFv2/@mtj.duckdns.org>
References: <cover.1617355387.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OZEUSqboDcw+HtCtMOSkDciT/SlQ5QAFuYRmXSX9rkA=;
        b=EnoTD+SOKtJxZf859K9o2lC02HkQGzWR/1z2Br3tVAqf2xxTDw+Ja+hz2EACyfqYT8
         UcM7QFDuLfNoiNDop7thhYp0jFMeRvEhmTdxP0w3qftVK253XoEpo+RG2T4nrytSYv5v
         EV0Ju1WP6YWLnCqaaz94hdImt/LN+of0HmC64US3iFacnvVLFsht8UaNXHQULktYGlCR
         l3fG6Um8cRrW0a0ca75HRtzObP0BtW+kZLFp3PKEM2aaNmhRdL1p3t5Su7wflHzlWm3L
         dexByUr8whbR7okUwSUcKxbEG8jJjcj2D4bSK28z9jIPSiK3IIelG9lzjQzgAPQvXhgb
         7VvQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1617355387.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lihaiwei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linussli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, herberthbli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, lennychen-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, allanyuliu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Sun, Apr 04, 2021 at 10:51:53PM +0800, yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> This patch is the init patch of a series which we want to present the idea
> of prioritized tasks management. As the cloud computing introduces intricate
> configurations to provide customized infrasturctures and friendly user
> experiences, in order to maximum utilization of sources and improve the
> efficiency of arrangement, we add the new attribute "priority" to control
> group, which could be used as graded factor by subssystems to manipulate
> the behaviors of processes.
> 
> Base on the order of priority, we could apply different resource configuration
> strategies, sometimes it will be more accuracy instead of fine tuning in each
> subsystem. And of course to set fundamental rules, for example, high priority
> cgroups could seize the resource from cgroups with lower priority all the time.
> 
> The default value of "priority" is set to 0 which means the highest
> priority, and the totally levels of priority is defined by
> CGROUP_PRIORITY_MAX. Each subsystem could register callback to receive the
> priority change notification for their own purposes. 
> 
> We would like to send out the corresponding features in the coming weeks,
> which are relaying on the priority settings. For example, the prioritized
> oom, memory reclaiming and cpu schedule strategy.

We've been trying really hard to give each interface semantics which is
logical and describable independent of the implementation details. This runs
precisely against that.

Thanks.

-- 
tejun
