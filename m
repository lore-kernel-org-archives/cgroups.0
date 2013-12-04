From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [lxc-devel] cgroup management daemon
Date: Wed, 4 Dec 2013 18:06:32 -0500
Message-ID: <20131204230632.GA10785@mtj.dyndns.org>
References: <20131125224335.GA15481@mail.hallyn.com>
 <20131203134506.GG8277@htj.dyndns.org>
 <20131204000344.GB24968@sergelap>
 <20131204012416.GY8277@htj.dyndns.org>
 <20131204023151.GA12376@sergelap>
 <CAO_RewbZiLCJcO9G7pgxN8ZxkkVdEW1B84nkQ5wX3a9DPq4zfg@mail.gmail.com>
 <20131204155437.GA29008@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QvDRWULCnUquijEAWJyt/m1uEPRFoHEjJLmrRabnsYo=;
        b=Lr5gmZdXbqXdfd8aElTCoETAtIqohW+cqWcfsVhAuYfntR4VNHM5HarHckNi5dP5WU
         T7vDsm7GSFkK1jBpgBM9Q4HG1GaXHL1SIq9YHuu3z9zcSsIXcAiQFA4saVtfc4wH9TaP
         seOLUBF/IevAap4zn6D2h+3DE/K+5D1pAb4FN+0MblKjjPI/kLmPS3NmmkEK0Tew4YYo
         KljqfLgm1Yvb+p4b70kcqUl3pCS9LCHQwtYWPbSyDUB00/R0LR3YfP0EBK8rCnuSyQCf
         ikZpnF3yR2kannZ+aKG4eUJdQS95nRvWd3KooRQrTZts2JHyGWOcPOJUd8EjlLRsb2Bu
         Kc8w==
Content-Disposition: inline
In-Reply-To: <20131204155437.GA29008@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Dec 04, 2013 at 09:54:37AM -0600, Serge Hallyn wrote:
> Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> > If this daemon works as advertised, we will explore moving all write
> > traffic to use it.  I still have concerns that this can't handle read
> > traffic at the scale we need.
> > 
> > Tejun,  I am not sure why chown came back into the conversation.  This
> > is a replacement for that.
> 
> Because the daemon is chowning directories and files.  That's how
> the daemon decides whether clients have access.

Ah, okay, so the manager is just using filesystem metadata for
bookkeeping.  That should be fine.  Please note that cgroup filesystem
also supports xattr and AFAIK systemd is already making use of it.

Thanks.

-- 
tejun
