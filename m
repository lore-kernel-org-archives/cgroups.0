From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Wed, 28 Jun 2023 07:58:48 -1000
Message-ID: <ZJx02OVPd4BJGmZk@slm.duckdns.org>
References: <20230627-kanon-hievt-bfdb583ddaa6@brauner>
 <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ@mail.gmail.com>
 <20230627-ausgaben-brauhaus-a33e292558d8@brauner>
 <ZJstlHU4Y3ZtiWJe@slm.duckdns.org>
 <CAJuCfpFUrPGVSnZ9+CmMz31GjRNN+tNf6nUmiCgx0Cs5ygD64A@mail.gmail.com>
 <CAJuCfpFe2OdBjZkwHW5UCFUbnQh7hbNeqs7B99PXMXdFNjKb5Q@mail.gmail.com>
 <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com>
 <ZJuSzlHfbLj3OjvM@slm.duckdns.org>
 <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
 <20230628-meisennest-redlich-c09e79fde7f7@brauner>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687975131; x=1690567131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qzqci8MIgjVyIUaoMuFMWhowYf714G+EhdihjPJLgC4=;
        b=JAO1w2EsXI/zq+eWUGmEP73JL7iOhBWV4lhCpiCiU6RN5gwNWB77X1NBAUmnwNGT/r
         wU4/m9Ru19vZvQDm2ByOZvYQngyoRsTMMwJM9+7HmOeHJS7xuFKVPqVmxPIBRdXZMa3C
         qKU9HAjqyLzxXGgD51nAY5LlvGeuvmoTBCROQPANrzDAO7Wyf2of3jrbf7DaQcgpWP2+
         90/N2JFkc/CMW+AJS+184bxNbK9I3p1SXDopemvaSFZgBS28ah1TwqYBbSsUHJj66V8f
         DjkyPURqn3aTYF/vfazJk7tl7dvpfMqWGArA77hqbNvWazGmmxa2tC9iBFexJh4SXLhy
         /TJQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230628-meisennest-redlich-c09e79fde7f7@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, gregkh@linuxfoundation.org, peterz@infradead.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

Hello,

On Wed, Jun 28, 2023 at 09:26:07AM +0200, Christian Brauner wrote:
> > I think the root cause of this problem is that ->release() in kernfs
> > does not adhere to the common rule that ->release() is called only
> > when the file is going away and has no users left. Am I wrong?
> 
> So imho, ultimately this all comes down to rmdir() having special
> semantics in kernfs. On any regular filesystem an rmdir() on a directory

Yeap, rmdir needs to revoke all the existing open files for kernfs to allow
the subsystem to disappear afterwards.

> which is still referenced by a struct file doesn't trigger an
> f_op->release() operation. It's just that directory is unlinked and
> you get some sort of errno like ENOENT when you try to create new files
> in there or whatever. The actual f_op->release) however is triggered
> on last fput().
> 
> But in essence, kernfs treats an rmdir() operation as being equivalent
> to a final fput() such that it somehow magically kills all file
> references. And that's just wrong and not supported.

It is not supported in linux vfs but kernfs users need it, so it's a
semantic implemented in kernfs, which does add some complications but that's
the cost we pay for solving the problem of allowing device drivers or
whatever backing kernfs to go away when they want to.

I'm not sure what classifying a behavior requirement as wrong means. Do you
mean that we shouldn't allow device drives to be unloaded if someone forget
to close a sysfs file?

Thanks.

-- 
tejun
