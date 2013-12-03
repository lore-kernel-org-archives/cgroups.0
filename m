From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 3 Dec 2013 09:00:53 -0500
Message-ID: <20131203140053.GJ8277@htj.dyndns.org>
References: <20131125224335.GA15481@mail.hallyn.com>
 <CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
 <20131126161246.GA23834@mail.hallyn.com>
 <CAD=mX8tCOEO4wP-XGs9YdRufTAay6zPaOxo_wZF=-KoqepH0wg@mail.gmail.com>
 <20131126164125.GC23834@mail.hallyn.com>
 <CAD=mX8v-jfA8F5DueK60Oo4Zfcjj86idKYKnDVc9LxQVs9W_rQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NLmo7mJ4zrgaXXbQeoYXKa9WvQSciP/VS6BjuPs/mXY=;
        b=C44qrsDO54mRUculizdLz7UuaGZ0HZ4CW0YEg8ythqYWILCRgX8NoWQn1SUgEtTO+/
         r7k/a8q7QhsDWK/iqjCZRpPMoMDouf2an85cEF2ui6LDDO6vpX3G6wrbDJqhFNLM5AXZ
         e0POApYek4GYC3yZZUfHPWVRbf8lnGiSIo34BxeB2dtKNnooXPEaqKtkQN9C0/5hNOGD
         yPdHmk0vPPsnK2Qto8cXxfnd1Mwl7Ez67Tik7016JTv90Ql4b+Z4wRlGebwmkHAt56xy
         wRLc9pHKpgbwQlMVcVV/m27Vmr1/ExcTelXcTommnIPJ0Y+mrvi+k0YeA2PF9pwAqUjk
         FYJQ==
Content-Disposition: inline
In-Reply-To: <CAD=mX8v-jfA8F5DueK60Oo4Zfcjj86idKYKnDVc9LxQVs9W_rQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

Hello,

On Tue, Nov 26, 2013 at 09:19:18AM -0800, Victor Marmol wrote:
> > > >From my discussions with Tejun, he wanted to move to using inotify so it
> > > may still be an fd we pass around.
> >
> > Hm, would that just be inotify on the memory.max_usage_in_bytes
> > file, of inotify on a specific fd you've created which is
> > associated with any threshold you specify?  The former seems
> > less ideal.
> >
> 
> Tejun can comment more, but I think it is still TBD.

It's likely the former with configurable cadence or per-knob (not
per-opener) configurable thresholds.  max_usage_in_bytes is a special
case here as all other knobs can simply generate an event on each
transition.  If event (de)muxing is necessary, it probably should be
done from userland.

Thanks.

-- 
tejun
