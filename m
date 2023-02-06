From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Using cgroup membership for resource access control?
Date: Mon, 6 Feb 2023 11:43:53 -1000
Message-ID: <Y+F0mXS9z0flDhf7@slm.duckdns.org>
References: <Y+FvQbfTdcTe9GVu@agluck-desk3.sc.intel.com>
 <Y+F0NA9iI0zlONz7@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J2KoQmbbXyDx/bLAsXkkqphx6KuZ7jSdX0FUGjC/cT4=;
        b=H1NKvYLM1eScv9Dqsa3OJ7+ladTqCD1+KAlq80Yb3KrBfF0JL2uAillw/F4XtL6q7K
         TUv7ChSi+dv61J/q8NYAMwjOnu28D7BJI0cxPh99jQXWbQh3SOy4XfN9M/aud8PMKh+K
         SeRYk8S5kNLheRyARIKDOcfvb/hODJ8ZyJiEVokNfCfTjcAzCVVZoi5/Qxqc7XmQWYur
         4HGUuijL02ne5KWfw5o3gSXRIpxIaclA4Vtt2N+SIoqbrTtQBOZvnpmMfxHZ+kgg7Brx
         NiN2WkDSbVRsx4w/3UjbvdICFiLHR1QDk/ImXlBrPwFU2PIGwvTgqzhWGKf+O/5bPM6X
         e31g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y+F0NA9iI0zlONz7-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ramesh Thomas <ramesh.thomas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon, Feb 06, 2023 at 11:42:12AM -1000, Tejun Heo wrote:
> The flip side is that on vast majority of configurations, cgroup hierarchy
> more or less coincides with process tree which has the benefit of being
> available regardless of cgroups, so in a lot of cases, it can be better to
> just go the traditional way and tie these things to the process tree.

In case it wasn't clear - use the misc controller to restrict which cgroups
can get how many but as for sharing domain, use more traditional mechanisms
whether that's sharing through cloning, fd passing, shared path with perm
checks or whatever.

Thanks.

-- 
tejun
