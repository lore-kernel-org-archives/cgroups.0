From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [lxc-devel] cgroup management daemon
Date: Wed, 4 Dec 2013 06:37:50 -0500
Message-ID: <20131204113750.GA3158@htj.dyndns.org>
References: <20131125224335.GA15481@mail.hallyn.com>
 <20131203134506.GG8277@htj.dyndns.org>
 <20131204000344.GB24968@sergelap>
 <20131204012416.GY8277@htj.dyndns.org>
 <20131204023151.GA12376@sergelap>
 <CAO_RewbZiLCJcO9G7pgxN8ZxkkVdEW1B84nkQ5wX3a9DPq4zfg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cAiCASyfodLKtuDP6Qz0h0rNHV3308TMXkQJhloFfbE=;
        b=dDDiy3aizWIkpFqoshkTHmzPxmPhjV7aBC8OE5ptSWe6M+m2nXaDtsGVHbIi7IlhDO
         rdhe27/dcrdsrV+hLr/Y7y4BJGlZf4TkZSCKEkUfKtPEpev4ytf04BmeeaAJ53czrW4g
         SG0+eRjB6dW6St9vAHc0/RBtaaBm7tWiagwYlyfRe91XawhaU0NU6XkcuRsYT2M9hsZj
         eHeLED7vqMdkTexdyZ49aJQYzR9iVKOFuYtVX76WoejIuOdeAqMXrmy+5VeJW4ikeIB2
         yVbA4qs/kc8hv6MHcj5IJlsO0J21fhJSOzlsIna936aHm/45mMTCAw3TcFr6K7Sy/0GF
         X0DA==
Content-Disposition: inline
In-Reply-To: <CAO_RewbZiLCJcO9G7pgxN8ZxkkVdEW1B84nkQ5wX3a9DPq4zfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello, Tim.

On Tue, Dec 03, 2013 at 08:53:21PM -0800, Tim Hockin wrote:
> If this daemon works as advertised, we will explore moving all write
> traffic to use it.  I still have concerns that this can't handle read
> traffic at the scale we need.

At least from the kernel side, cgroup doesn't and won't have any
problem with direct reads.

> Tejun,  I am not sure why chown came back into the conversation.  This
> is a replacement for that.

I guess I'm just confused because of the mentions of chown.  If it
isn't about giving unmoderated write access to untrusted domains,
everything should be fine.

Thanks!

-- 
tejun
