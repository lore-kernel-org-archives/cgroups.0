From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 01/12] kernfs: add function to find kernfs_node without
 increasing ref counter
Date: Mon, 12 Nov 2018 17:56:27 -0800
Message-ID: <20181113015627.GI21824@bombadil.infradead.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <20181112095632.69114-2-paolo.valente@linaro.org>
 <20181112122840.GA1429@kroah.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xyhICmvadfrnShpHejrsXRbuDAeIhRd9ectqbLmueZA=; b=iXVSsNlFsAiI3I4EY907z5TGd
        aOIvOLQbdGrhToOPGeoryVn3DnrPvG/oqNqfIZK8Dx30KeC6Dr29RXFhGXj1aGDmZMYrRr7sKhiEO
        I74K7SDSKHUxA8XwkgAz0LW8vDQa5ZGJi6EYatt9h9w+nXW789bALNxTNYGyKjBgGN5ynOWxen9BS
        cEsesZJw0KP0jpqizcK48bJwAFBlybbApjIPVBAg9+BlnWLhCX9DxSUaev0aQhsovEAyf3ci2/4wn
        7bSt/VoeK6Qju5dgIQ+ZiGZJG2N3oJeA5pWQjAq2MMzPey+ytgwkaWRNFwMWB2tvGx4TMrHgBieBl
    
Content-Disposition: inline
In-Reply-To: <20181112122840.GA1429@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

On Mon, Nov 12, 2018 at 04:28:40AM -0800, Greg Kroah-Hartman wrote:
> On Mon, Nov 12, 2018 at 10:56:21AM +0100, Paolo Valente wrote:
> > From: Angelo Ruocco <angeloruocco90@gmail.com>
> > 
> > The kernfs pseudo file system doesn't export any function to only find
> > a node by name, without also getting a reference on it.
> > But in some cases it is useful to just locate a kernfs node, while
> > using it or not depends on some other condition.
> > 
> > This commit adds a function to just look for a node, without getting
> > a reference on it.
> 
> Eeek, that sounds really bad.  So you save off a pointer to something,
> and have no idea if that pointer now really is valid or not?  It can
> instantly disappear right afterwards.
> 
> This feels wrong, what is the problem of having a properly reference
> counted object passed back to you that you have to create a dangerous
> function like this?

I agree with Greg, this function is dangerous.  What's wrong with using
find_get and then doing a put once you successfully take it over, or
fail to take it over?
