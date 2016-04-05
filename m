From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 5 Apr 2016 07:25:11 -0700
Message-ID: <CAG53R5V=-sRacw7kX-UhjRmr+LS3HF4u8yfQF16utAxo-YHnMw@mail.gmail.com>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
	<1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
	<20160404193640.GA7822@mtj.duckdns.org>
	<CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
	<20160405012504.GG24661@htj.duckdns.org>
	<CAG53R5Xs9nB_g7pDu6G260EY+iu6hi=fs6eV1ggyk=NwO32oRg@mail.gmail.com>
	<20160405140107.GB7822@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=/eGzaQ3VCqbAk7sLcupvTWOhzDYvn7FcEGmrcju74qY=;
        b=l6MKHh/kvgZczmKlpiSfRYFRsBl7y07RRYkQdI7kcBQN5s66qRgj0dbwZTS5BGcuPg
         P1fvRTMgriR4h11q0j+3L8QYuMyd+dvuiSlxztiH0ESRUPAIH6xqIZo6rsiPwcGytCJ6
         chmNzhp0X/qIeqWWJtoWljsr82xCENx0zy3ah4dVFPer2g/vZvqJm4ubq7XfOTfnzBke
         RqrxiRIlqA7B1EPA9J7UXx70+rhWty3/XI6zUy9qChm+VqlargDPplUUDvcjEggrh4PQ
         TPZZsHlTyBA41cTV4B/oXAW8h+5qkh1sCazd4Bdu4w/FUTkXqs2XqLp3C6p40OFKO5Y6
         OzQA==
In-Reply-To: <20160405140107.GB7822-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 5, 2016 at 7:01 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Mon, Apr 04, 2016 at 07:22:38PM -0700, Parav Pandit wrote:
>> > Is it actually customary to have rdma core module updated more
>> > frequently separate from the kernel?  Out-of-tree modules being
>> > updated separately happens quite a bit but this is an in-kernel
>> > module, which usually is tightly coupled with the rest of the kernel.
>> >
>> Yes.
>> rdma core module is compiled as kernel module.
>> Its often updated for new features, fixes.
>> So kernel version can be one but RDMA core module(s) get updated more
>> frequently than kernel.
>
> As it is a fairly isolated domain, to certain extent, it could be okay
> to let it go.  At the same time, I know that these enterprise things
> tend to go completely wayward and am worried about individual drivers
> going crazy with custom attributes in a non-sensical way.

If its crazy at driver level, I am sure it will be equally crazy for
any end-user too. Therefore no user would use those crazy resources
either.
Intent is certainly not for the individual drivers as we agreed in
past. IB stack maintainers would be reviewing new enum addition
anyway, whether its verb or hw resource (unlikely).

> The
> interface this patch is proposing easily allows that and that at the
> cost of internal engineering flexibility.  I don't really want to be
> caught up in a situation where we're forced to include broken usages
> because that's what's already out in the wild.  I personally would
> much prefer the resources to be defined rigidly.  Let's see how the
> discussion with Christoph evolves.
>
Sure. I will wait for his comments.

>> > I don't remember the details well but the code was vastly more complex
>> > back then and the object lifetime management was muddy at best.  If I
>> > reviewed in a contradicting way, my apologies, but given the current
>> > code, it'd be better to have objects creation upfront.
>>
>> Do you mean,
>> try_charge() should
>> lock()
>> run loop to allocate in hierarchy, if not allocated.
>> run loop again to charge.
>> unlock()
>>
>> If so, I prefer to run the loop once.
>
> In the original review message, I mentioned creating an interface
> which creates the hierarchy of objects as necessary and returns the
> target pool with lock held, can you please give it a shot?  Something
> like the following.

o.k. I will attempt. Looks doable.
I am on travel so it will take few more days for me to turn around
with below approach with tested code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
