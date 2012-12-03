From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] device_cgroup: prepare exception list handling
 functions for two lists
Date: Mon, 3 Dec 2012 09:31:28 -0800
Message-ID: <20121203173128.GH19802@htj.dyndns.org>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.078661224@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=z9e0GEcsSIsMZejLkdTF80hvfq4mMArdmuxt9fkOH00=;
        b=JHQfzQI2ZfEsQjvY0n0lqYkmDJ3Pdm+NbMJZrkZ8l7ohElxEDb+WJNzH+UrCEgTrWL
         qh7y58ZO8aIjxqa1DaqWKPZtDTqVyeXgvGWE/WxdnCqSUAb2nh6I/j+9woQEnm6a3Xpy
         n/vwWjokmcq93D87A1RTO3p79svIn5wyPX1gl67rq9EBTGUbNQkNgLIqf0oPLQAXJ1Pq
         6BBvG0bd66HLwVbFZMHfP2Z3mrSBbrkL1Y0yGUWJ++sh4lpKtBG7V5ka099a8syn1lwa
         WrP15MmybNX/fCtkIMfPHYOxkjfJ6P/vAczIdWNY1NWYOwWoiyOey3qbITcWpJiT+9cJ
         OE0Q==
Content-Disposition: inline
In-Reply-To: <20121127193502.078661224-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 27, 2012 at 02:35:03PM -0500, Aristeu Rozanski wrote:
> In the following patches, device_cgroup structure will have two sets of
> behavior and exceptions list (actual one, another with the local settings)
> so rework the functions to use exception list, not a device_cgroup.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
