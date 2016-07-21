From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 11:26:48 -0400
Message-ID: <20160721152648.GA23759@htj.duckdns.org>
References: <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
 <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
 <20160721145242.GB22680@htj.duckdns.org>
 <1469113456.2331.16.camel@HansenPartnership.com>
 <20160721150740.GF22680@htj.duckdns.org>
 <1469114194.2331.20.camel@HansenPartnership.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q5YuyWAy+rR6yZ1+2uPjLz6BfOpECsoAhOm0KqaoAyg=;
        b=0Bv2Sp+VuD/K1p6zcqPCvmnAACYx6NL5O4k1/xafKmwJferdUURvWcvPu3M8VjV375
         nFVSQjLPsrk31sH05CJagNPuAoT33pmK4LP/ItvQizPmUH8rwVw1V5zrZFiHdVqXwj+C
         50njjmYQ517WpbBAp3+cH6fIon95IAN7nt8z9WyUtVBw/7TXuM/ox9DAn43NU7Ng47Uq
         IDE20ksLvz7A+GwSmddTegi/6jBdK8a039tvFdTZX6i9LTmWiWmVA0VpZLmVU6Au8SU0
         z3AdOZjzj9VIVgCwh+jeiVUCxBxjyyH1efeweAZILzLsBusDaCilleOJaane+ajSdJhE
         3bQg==
Content-Disposition: inline
In-Reply-To: <1469114194.2331.20.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aleksa Sarai <asarai@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Aditya Kali <adityakali@google.com>, Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Christian Brauner <cbrauner@suse.de>, dev@opencontainers.org

Hello, James.

On Thu, Jul 21, 2016 at 08:16:34AM -0700, James Bottomley wrote:
> > That'd be one side.  The other side is the one moving.  Let's say the
> > system admin thing wants to move all processe from A proper to B.  It
> > would do that by draining processes from A's procs file into B's and
> > even that is multistep and can race.
> 
> So the second part is that once we allow the creation of
> subdirectories, there's no unified tasks file, so there's no way of
> draining A proper without enumerating and descending into the cgroupns
> created subtrees in A?

Not that.  If it races, it will end up moving processes which are no
longer in A proper.  Such operations or distinctions might not be
meaningful under many circumstances but it'd be a pretty big hole in
the API to create and I can't really declare these holes are gonna be
okay with confidence.

Thanks.

-- 
tejun
