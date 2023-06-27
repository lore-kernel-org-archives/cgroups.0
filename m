From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 08:42:28 -1000
Message-ID: <ZJstlHU4Y3ZtiWJe@slm.duckdns.org>
References: <20230626201713.1204982-1-surenb@google.com>
 <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
 <20230627-kanon-hievt-bfdb583ddaa6@brauner>
 <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ@mail.gmail.com>
 <20230627-ausgaben-brauhaus-a33e292558d8@brauner>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687891349; x=1690483349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5QW7db0ayiyIii0yaz366+aZQikC9TPomjktNVfLgKA=;
        b=lTr0hPUu+VSVtxwnzjFuIRI9fc2sezvUzFVC3QJLaIUaPBLttHamZsk0+Na3/KhHum
         T1GmICHTIIx7C8O4sKGGK/ME2bplCuDjHc0yJC/t/ECBWLFqR8IOPaDtfAUm6IJWis8p
         E+mZ6PcUkk8PlwmxtxskER3VPhYzmBW8U+9EI0mUotQw7jiwQkev/lxkpGr/n0mGzPQQ
         dodKIJVJGzSXEi0kYRhOFE5eu+uvvEemXy30zh6pKiqN2jepRPZUbd7lU9BwpLLHOjXH
         rRt/Au0fKNeDsWkF1ix2x+SOUPNHd0mIQd1uZwRLaPbUIajqifgjIfOysAm2KmQKl46A
         TXaQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230627-ausgaben-brauhaus-a33e292558d8@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, gregkh@linuxfoundation.org, peterz@infradead.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

Hello, Christian.

On Tue, Jun 27, 2023 at 07:30:26PM +0200, Christian Brauner wrote:
...
> ->release() was added in
> 
>     commit 0e67db2f9fe91937e798e3d7d22c50a8438187e1
>     kernfs: add kernfs_ops->open/release() callbacks
> 
>     Add ->open/release() methods to kernfs_ops.  ->open() is called when
>     the file is opened and ->release() when the file is either released or
>     severed.  These callbacks can be used, for example, to manage
>     persistent caching objects over multiple seq_file iterations.
> 
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Acked-by: Acked-by: Zefan Li <lizefan@huawei.com>
> 
> which mentions "either releases or severed" which imho already points to
> separate methods.

This is because kernfs has revoking operation which doesn't exist for other
filesystems. Other filesystem implemenations can't just say "I'm done. Bye!"
and go away. Even if the underlying filesystem has completely failed, the
code still has to remain attached and keep aborting operations.

However, kernfs serves as the midlayer to a lot of device drivers and other
internal subsystems and it'd be really inconvenient for each of them to have
to implement "I want to go away but I gotta wait out this user who's holding
onto my tuning knob file". So, kernfs exposes a revoke or severing semantics
something that's exposing interface through kernfs wants to stop doing so.

If you look at it from file operation implementation POV, this seems exactly
like ->release. All open files are shutdown and there won't be any future
operations. After all, revoke is forced closing of all fd's. So, for most
users, treating severing just like ->release is the right thing to do.

The PSI file which caused this is a special case because it attaches
something to its kernfs file which outlives the severing operation bypassing
kernfs infra. A more complete way to fix this would be supporting the
required behavior from kernfs side, so that the PSI file operates on kernfs
interface which knows the severing event and detaches properly. That said,
currently, this is very much an one-off.

Suren, if you're interested, it might make sense to pipe poll through kernfs
properly so that it has its kernfs operation and kernfs can sever it. That
said, as this is a fix for something which is currently causing crashes,
it'd be better to merge this simpler fix first no matter what.

Thanks.

-- 
tejun
