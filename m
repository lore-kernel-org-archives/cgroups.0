From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Mon, 25 Jul 2016 14:44:53 -0400
Message-ID: <20160725184453.GF19588@mtj.duckdns.org>
References: <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
 <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
 <20160721145242.GB22680@htj.duckdns.org>
 <1469113456.2331.16.camel@HansenPartnership.com>
 <20160721150740.GF22680@htj.duckdns.org>
 <7e004486-b402-6e01-9893-c8751bcdb316@suse.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W44v/Hbi9meF13W6K8ETuyrwvlx1dxHDNEk2KdvFOwM=;
        b=kI2y3H/Ie0TtIcIlchyoL6HHwOn5izxyRhnVIzc6Bt5vMU+Y5+KV21H7Gx1ElJ0EPC
         K/mmPolhPWb5Rt8GKiikiFas1p+YNxqtYL+U1/obl9NG4Jdj+v10dNtKXxXBJUPwm6NN
         2fcGReFXmvIVHm0WFIxnoKb/WyuY+MtBXAHyJ2yECaa4VKWf5O9Du6AYkQ2CM6w5QKut
         Wqkq0LwcTfzbr8z7kKfyPTeaZBhSeEKmfzZDJDWK2y25/V2e56FspwiH7SYpKCPdsLDq
         e98+tX/K8CHBpvCYvODpjOjzNcwfeLmsDYuLZJFgxZAMwHGTKYGFMCCcTM3aldco2Ldy
         aY7Q==
Content-Disposition: inline
In-Reply-To: <7e004486-b402-6e01-9893-c8751bcdb316@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Aditya Kali <adityakali@google.com>, Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Christian Brauner <cbrauner@suse.de>, dev@opencontainers.org

On Fri, Jul 22, 2016 at 06:24:25PM +1000, Aleksa Sarai wrote:
> > >  It's about the debris left behind if the admin (or someone with
> > > delegated authority) moves the task to a wholly different cgroup.
> > > 
> > > Now we have a cgroup directory in the old cgroup, which the current
> > > task has been removed from, for which the current user has permissions
> > > and could then move the task back to.  Is that the essence of the
> > > problem?
> > 
> > That'd be one side.  The other side is the one moving.  Let's say the
> > system admin thing wants to move all processe from A proper to B.  It
> > would do that by draining processes from A's procs file into B's and
> > even that is multistep and can race.
> 
> Once freezer is ported, wouldn't that allow you to stop the processes so you
> can drain them? I understand your concern with draining, but surely the same
> races occur if you fork? How many times would you need to scan cgroup.procs
> to make sure that you didn't miss anything (and if there's enough processes
> then cgroup.procs reads aren't atomic either).

Sure, draining has to be iterative and in actual use cases freezing
would help but I think you're misunderstanding why I gave the example.
It wasn't meant to be "if you solve this problem case, we're all
good".  It was an illustration of the underlying problems where the
basic interface isn't fit for this sort of complex semantics.  Please
take a step back and look at the larger picture.  The current
interface is silly in many areas but it's still mostly integral and
I'd really like to keep at least that.

If there is a way to do this in a way which is not hacky, we can
definitely look into it.  However, given that the imminent problem is
relatively small, I'm not too sure that there would be a solution of
justifiable size.

Thanks.

-- 
tejun
