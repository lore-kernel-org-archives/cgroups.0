From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11 1/3] cgroup: mark "tasks" cgroup file as
 insane
Date: Fri, 7 Jun 2013 13:03:07 -0700
Message-ID: <20130607200307.GA14781@mtj.dyndns.org>
References: <20130604021302.GH29989@mtj.dyndns.org>
 <20130604111556.GA4963@redhat.com>
 <20130604201947.GE14916@htj.dyndns.org>
 <20130606092055.GF30217@redhat.com>
 <20130606211410.GF5045@htj.dyndns.org>
 <20130607051040.GA1364@tango.0pointer.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Q1Hl8NpndVOQzm0oiKb7jeKkJmI+EZhp1vkVVF7QVO8=;
        b=qLs6raPiwaXZGdPsJ+9gVl/Gg/2fZ8blamq3AizJqyCaHt/Tl1gHZTiM1hc3mYb6tG
         yTjXkX3vUTJ6WDh/dbEpg2M+8qx6cVFsOUeRqPDXudTurUWvWt35fceNhwUD9q1Jmrvi
         Ghv7RE0RcRyZegiciA6SsNC6YzDcLtDr6Vq+9CqRDUBFDk8X+95cedirnAg1TDeWqa3m
         HO+VKgwmcJTkrWR24CqGGLj8mD7HWp4tEDP9+ooG2wKucFo+qRm35YVVF8Q90Y/6/P76
         VAvxIYvtdXImlvxkcZvjIaonck6CrsPJPRMv8XjsOcAEA6CuivUcUfyqs0KAJF5KSbSs
         BG8Q==
Content-Disposition: inline
In-Reply-To: <20130607051040.GA1364-kS5D54t9nk0aINubkmmoJbNAH6kLmebB@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Cc: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Lennart.

On Fri, Jun 07, 2013 at 07:10:40AM +0200, Lennart Poettering wrote:
> Uhm. So I don't think we will support two ways to set this up for long
> in systemd (if at all). And even if we did, the distributions would pick
> one or the other as default, and if you are unlucky, then you couldn't
> run libvirt on it without reconfiguration and rebooting to get the other
> cgroup setup logic...

Hmmm... would that mean that people wouldn't be able to boot older
kernel w/o unified hierarhcy with new systemd fairly soon too?  We can
make the new features which matter for management available for named
mounts (w/o unified hierarchy) so that systemd can operate as if none
of the actual controllers are enabled, which it should be able to
handle anyway.  That wouldn't solve booting old kernels with new
systemd problem but it should at least allow workable backward
compatibility from userland side as long as the kernel keeps the
compatibility, right?

Thanks.

-- 
tejun
