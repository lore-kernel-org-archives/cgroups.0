From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: use cgroup_subsys_state as
 the primary subsystem interface handle
Date: Thu, 8 Aug 2013 20:12:38 -0400
Message-ID: <20130809001238.GA13427@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DN0wFDS27zvUUDmB8Ucz34zCablKmNeXjLrXrMS1DwI=;
        b=qwP4U1GfFI9i1xpL6Fc/p8b9QP8MJwoOkuFym7PSBuTzQ+pi7ExI+8JoMEcSwA7Xps
         bhS6GryhmNInpAgxP/Glr2u/7VwNmaKHghKurHGy+p0ItINtYs6WD2m6RGdvmIB8Rn4Z
         aoAGHFYvNo8osibh9lU4j/m/VO96N8m6/Y604BYV3TrMsZ824Zow1YFYXY9/GydH3j84
         EwPi3pyLq+fhomJbDbBjp9SMQbxz4bmB/jsTXJ6dTsPpLNbqjkisKPFpyL0greQxWGfN
         TZFUiArxK5HX9DqxqrE7OGT2w7UN4oWFgDlXiyVdngPEbqllPC1ilojTnjt1OekEx6z/
         mojw==
Content-Disposition: inline
In-Reply-To: <1375393801-4817-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 01, 2013 at 05:49:38PM -0400, Tejun Heo wrote:
> So, this patchset converts all cgroup subsystem APIs to deal with
> css's instead of cgroups.  The patchset is fairly large but most of
> the conversions, while being tedious, aren't complex.  At the end of
> series, subsystems no longer make cgroup -> css mapping themselves and
> cgroup_css() - formerly cgroup_subsys_state() - is made internal to
> cgroup core proper.

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
