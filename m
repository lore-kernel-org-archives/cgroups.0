From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Why does devices cgroup check for CAP_SYS_ADMIN explicitly?
Date: Tue, 6 Nov 2012 07:06:39 -0800
Message-ID: <20121106150639.GB30069@mtj.dyndns.org>
References: <20121106023845.GI19354@mtj.dyndns.org>
 <877gpzrlir.fsf@xmission.com>
 <20121106150131.GA14640@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UAm76AN1V6rjES4Wg9pGP7xO0aOFrX9S42AFwb4jnX8=;
        b=AY8l4SdpQRMA54txjEnIMDQ0gUtM9QBDb8zBha6zaNYAOuT32PdjNDcYV21/ME9/3G
         +Z1+Fk7jigy7N4Dcr8/DVbn6O2JWf6WvMlGN8ZeaS5D3O41bNghFkWRDkVlMPPgVNn36
         oQCJJy9zMmJk3fxeTqjt0KP3LrFpmtv9FsNIcqBgBmQ9A+JrZScCPCqXJH0Dk1JTEH2S
         k3Dj2tjhtmpejwNV8lqY2dvnRB2zSfGSDy3yZ0kER6FJl+WTkY8EtA1AIjz2m6hbIN7i
         MkCUOA2yUsxV+2WYOmoJCPzMCiahHKGYUP23E8dgCHmepm3IakZSmuD1wR2oQ8tHwtcc
         L++Q==
Content-Disposition: inline
In-Reply-To: <20121106150131.GA14640@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Serge.

On Tue, Nov 06, 2012 at 09:01:32AM -0600, Serge Hallyn wrote:
> More practically, lacking user namespaces you can create a full (i.e.
> ubuntu) container that doesn't have CAP_SYS_ADMIN, but not one without
> root.  So this allows you to prevent containers from bypassing devices
> cgroup restrictions set by the parent.  (In reality we are not using
> that in ubuntu - we grant CAP_SYS_ADMIN and use apparmor to restrict -
> but other distros do.)

Do you even mount cgroupfs in containers?  If you just bind-mount
cgroupfs verbatim in containers, I don't think that's gonna work very
well.  If not, all this doesn't make any difference for containers.

So, you don't really have any actual use case for the explicit CAP_*
checks, right?

Thanks.

-- 
tejun
