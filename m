From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/12] kernfs: add function to find kernfs_node without
 increasing ref counter
Date: Tue, 13 Nov 2018 11:35:38 -0800
Message-ID: <20181113193538.GA5096@kroah.com>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <20181112095632.69114-2-paolo.valente@linaro.org>
 <20181112122840.GA1429@kroah.com>
 <07A5F685-9D7D-42A7-9A10-73C658F47435@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542137738;
        bh=IdQcfyuvdm+re6Cg0ueAy5cNXPj5ZQVuW0IBiT0DzBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HTWv29RID+GfRKNj/L/QDgwP4Af7T59ZxO2+iJZTCbsp8+PVNYmnlEmpKsQ+VxntY
         8WtRdw7JzUB6mH4FOvAfSPay/tZeggDYYQEBYxmbIwnGCaqquT5oC+sQx127rpywA1
         NyWHM46k5n3NXz1B1LAn1OTfiulTA3OeK2QAHWjo=
Content-Disposition: inline
In-Reply-To: <07A5F685-9D7D-42A7-9A10-73C658F47435@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

On Tue, Nov 13, 2018 at 06:53:59PM +0100, Paolo Valente wrote:
> 
> 
> > Il giorno 12 nov 2018, alle ore 13:28, Greg Kroah-Hartman <gregkh@linuxfoundation.org> ha scritto:
> > 
> > On Mon, Nov 12, 2018 at 10:56:21AM +0100, Paolo Valente wrote:
> >> From: Angelo Ruocco <angeloruocco90@gmail.com>
> >> 
> >> The kernfs pseudo file system doesn't export any function to only find
> >> a node by name, without also getting a reference on it.
> >> But in some cases it is useful to just locate a kernfs node, while
> >> using it or not depends on some other condition.
> >> 
> >> This commit adds a function to just look for a node, without getting
> >> a reference on it.
> > 
> > Eeek, that sounds really bad.  So you save off a pointer to something,
> > and have no idea if that pointer now really is valid or not?  It can
> > instantly disappear right afterwards.
> > 
> 
> Hi Greg,
> that function is invoked only in functions executed with cgroup_mutex
> held.  This guarantees that nothing disappears or becomes
> inconsistent.  That's why we decided to go for this optimization,
> instead of doing useless gets&puts pairs.  Still, I'm not expert
> enough to state whether it is impossible that, once we have defined
> that function, it may then get used in some unsafe way.

I can guarantee once you define that function, it will be used in an
unsafe way :(

So just don't create it, use the put calls, it's fast and should never
be a performance issue.

> So, I seem to see two options:
> 1) Add a comment on the function, saying that cgroup_mutex must be
>    held while invoking it (I guess you won't like this one).

Nope, do not create it.

> 2) Do not define such a new function, and, in the other patches, use
>    the already-available find_and_get.

Yes, please do that.

thanks,

greg k-h
