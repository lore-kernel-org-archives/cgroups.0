From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 15:54:22 -1000
Message-ID: <ZJuSzlHfbLj3OjvM@slm.duckdns.org>
References: <20230626201713.1204982-1-surenb@google.com>
 <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
 <20230627-kanon-hievt-bfdb583ddaa6@brauner>
 <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ@mail.gmail.com>
 <20230627-ausgaben-brauhaus-a33e292558d8@brauner>
 <ZJstlHU4Y3ZtiWJe@slm.duckdns.org>
 <CAJuCfpFUrPGVSnZ9+CmMz31GjRNN+tNf6nUmiCgx0Cs5ygD64A@mail.gmail.com>
 <CAJuCfpFe2OdBjZkwHW5UCFUbnQh7hbNeqs7B99PXMXdFNjKb5Q@mail.gmail.com>
 <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687917264; x=1690509264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n0MVrDy8BC1VnZ5USZJqaLNtQbygF6zhnK+O+s/tz1M=;
        b=beLe2IAe4ALEHVCEEp7ti+HifRhB8JISUuJR9mQdDKWrXu5q3NdZp/3y8FFgQ6OJ5S
         9zw4gEyWvSBxuHFa/Y1NWrl5X7jNGm26hGrFPd/CIhHAyPbQ4ez+yCftSlcgeSb3u6WF
         ad1Fke/gZaSQMKlPp0aF94UkmQQ46pNryDbJHp9j65OhZABBYya/irPIaXZLKypIz7u+
         jEfYUvOKj9Z4+Xc9WHXvPjOqnyi548hx7+xtZOwt6zI2gu15Co3LWtf6+JaiSB/sihYv
         6OlP2q4YXv7QceFk8f34cqIV/0Alxx3wGXIoO8v6tuT+rEjXx47++djXJdixE91aMI3K
         /gPg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>, gregkh@linuxfoundation.org, peterz@infradead.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

Hello,

On Tue, Jun 27, 2023 at 02:58:08PM -0700, Suren Baghdasaryan wrote:
> Ok in kernfs_generic_poll() we are using kernfs_open_node.poll
> waitqueue head for polling and kernfs_open_node is freed from inside
> kernfs_unlink_open_file() which is called from kernfs_fop_release().
> So, it is destroyed only when the last fput() is done, unlike the
> ops->release() operation which we are using for destroying PSI
> trigger's waitqueue. So, it seems we still need an operation which
> would indicate that the file is truly going away.

If we want to stay consistent with how kernfs behaves w.r.t. severing, the
right thing to do would be preventing any future polling at severing and
waking up everyone currently waiting, which sounds fine from cgroup behavior
POV too.

Now, the challenge is designing an interface which is difficult to make
mistake with. IOW, it'd be great if kernfs wraps poll call so that severing
is implemented without kernfs users doing anything, or at least make it
pretty obvious what the correct usage pattern is.

> Christian's suggestion to rename current ops->release() operation into
> ops->drain() (or ops->flush() per Matthew's request) and introduce a
> "new" ops->release() which is called only when the last fput() is done
> seems sane to me. Would everyone be happy with that approach?

I'm not sure I'd go there. The contract is that once ->release() is called,
the code backing that file can go away (e.g. rmmod'd). It really should
behave just like the last put from kernfs users' POV. For this specific fix,
it's safe because we know the ops is always built into the kernel and won't
go away but it'd be really bad if the interface says "this is a normal thing
to do". We'd be calling into rmmod'd text pages in no time.

So, I mean, even for temporary fix, we have to make it abundantly clear that
this is not for usual usage and can only be used if the code backing the ops
is built into the kernel and so on.

Thanks.

-- 
tejun
