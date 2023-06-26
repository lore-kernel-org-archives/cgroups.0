From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Mon, 26 Jun 2023 13:39:18 -0700
Message-ID: <CAJuCfpGt8Bg1VLkx-aMw7_JTvh=co4QSM9B=fvikp0mQ-6rvjg@mail.gmail.com>
References: <20230626201713.1204982-1-surenb@google.com> <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687811970; x=1690403970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEFUJeeBn6YjH4lK418olg3ruMKuxKIepWsfszUOpy4=;
        b=L6+t78u34A4EOsgO/5wyxp0/LGY+KJO2+xEm2/un0aE1W+UJ2WdK6S/UKVpguxRp5L
         R5MBxyaqs+VsDVFucNqfi5acwzpetEuEiNoaZ8TINLUMNyLQrLw5ImKiNAUPyZP6AkhM
         z9B43yz4ZPCStialiseimZwqXg90RajcVEsWa9D609XnTsfkElxPVXq9vzh/7VCTNHVv
         ziS22l4ZeeTvBn6hGJgR0FsPhw4xt3yYJhqLCQR4EOQ9FePLgVx2Z54nPJ8gKrH0uwRL
         cxZ5QZHAFRxraqfIGAatLgaElWfrPTD/K+Aa76+FxYyYGofVf9k/HTmhNNqiY77DmCW5
         0/5w==
In-Reply-To: <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, peterz@infradead.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

On Mon, Jun 26, 2023 at 1:31=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> On Mon, Jun 26, 2023 at 01:17:12PM -0700, Suren Baghdasaryan wrote:
> > diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> > index 73f5c120def8..a7e404ff31bb 100644
> > --- a/include/linux/kernfs.h
> > +++ b/include/linux/kernfs.h
> > @@ -273,6 +273,11 @@ struct kernfs_ops {
> >        */
> >       int (*open)(struct kernfs_open_file *of);
> >       void (*release)(struct kernfs_open_file *of);
> > +     /*
> > +      * Free resources tied to the lifecycle of the file, like a
> > +      * waitqueue used for polling.
> > +      */
> > +     void (*free)(struct kernfs_open_file *of);
>
> I think this can use a bit more commenting - ie. explain that release may=
 be
> called earlier than the actual freeing of the file and how that can lead =
to
> problems. Othre than that, looks fine to me.

Sure, once I get more feedback I'll post the next version with
expanded description.
Thanks!

>
> Greg, as Suren suggested, I can route both patches through the cgroup tre=
e
> if you're okay with it.
>
> Thanks.
>
> --
> tejun
