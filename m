From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Cgroups v2 thread mode "domain invalid" state
Date: Fri, 22 Dec 2017 10:11:00 +0100
Message-ID: <CAKgNAkhWhw8LNBdVZPzZ73VOmXDrxzSUD862AHduAhs3CF0bNw@mail.gmail.com>
References: <CAKgNAkg2u=zt87tKk35vR+tQ7DnkJp9vbj+8n88=_MCcvmH9oQ@mail.gmail.com>
 <20171222001554.GH1084507@devbig577.frc2.facebook.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=JuDatRNrUhSJ1HzIYACB/N2qOieLsigl9YgtgrYi62Y=;
        b=DBHWVHesVrijTFoEFzfywTAXpd//T5mZ14+vbJJfnYOMbEkU3k9NY5ancMKGYlU3EN
         VPqHPbeb4XeZeTQf0jl2upN9iSwVXythEeNm2r7RRkxjCkb92Cq71icNIZxqo4PYujOR
         CnKuin9g6fNSnBJDY1e3JQs4YsNfBOViIN8IWYM7URiFHnJVciaKKEe6ACe/61ne61KY
         QRM5yqSi4VemuUXm+xXKm5JngRJ6zzA0HBgKElKNq+IwnuTCTxBqbwJAYtE9sAP9qucZ
         MsNGg+76Fmhik6CzcRKHm5FmwQXv9qjs0TbNZLGY8q8zijBMzKrdFWFkWWh0Pc8O+MXi
         wH+A==
In-Reply-To: <20171222001554.GH1084507@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, longman@redhat.com, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

Hi Tejun,

On 22 December 2017 at 01:15, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, Dec 20, 2017 at 09:32:04PM +0100, Michael Kerrisk (man-pages) wrote:
>> I did find the July 2017 mail thread
>> "[PATCH 5/6] cgroup: implement cgroup v2 thread support"
>> (https://marc.info/?t=150025735500001&r=1&w=2)
>> where this cgroup type was discussed, but I must admit that I still
>> don't get it. Instead of converting cgroups under a threaded subtree
>> to "domain invalid" type, why can't they just be turned straight into
>> "threaded" type?
>>
>> I guess another way of asking this question is: what possibilities
>> does manually switching each "domain invalid" cgroup to "threaded"
>> allow that wouldn't be allowed by immediately making all of the
>> cgroups in a threaded subtree "threaded"?
>
> IIRC, there were two reasons.  (Writing from memory, so I might not be
> completely accurate.)
>
> * Consistency w/ the cgroups right under the root cgroup.  Because
>   they can be both domains and threadroots, we can't switch the
>   children over to thread mode automatically.  Doing that for cgroups
>   further down in the hierarchy would be really inconsistent.

I don't get the above. I mean, if we have the following hierarchy,
where R is the cgoup v2 mount point:

R---A(d)------B(d)
 \       \----C(d)
  \
   \
    X(d)------Y(d)

And we write "threaded" to A/cgroup.type, then we end up with:

R---A(t)------B(di)
 \       \----C(di)
  \
   \
    X(d)------Y(d)

(To be clear: "(d)" means "domain", "(di)" means "domain invalid", and
"(t)" means "threaded".)

But equally (in another world), that operation could have resulted in:

R---A(t)------B(t)
 \       \----C(t)
  \
   \
    X(d)------Y(d)

It's not clear to me how "Doing that for cgroups further down in the
hierarchy would be really inconsistent", since in the current
implementation, those same thread groups are converted to "domain
invalid" type.  What am I missing?

But, regarding the next point:

> * Possible extension to threadmode.  If we figure out how to do mixed
>   mode further down in the hierarchy (and if there are actual use
>   cases which require that), automatically switching would be really
>   confusing.
>
> The invalid state while not the most convenient is straight forward
> (only the operations which are explicitly asked are performed) and
> keeps the door open for future changes.

The "allowing for future" extensions idea makes some sense to me.

One other point that occurred to me after I wrote my email yesterday
was that if the threaded root reverts from being "domain threaded" to
"domain" (because it no longer has "threaded" children AND either it
has no member processes or it has no threaded controllers enabled),
then the "domain invalid" descendants revert to type "domain". I'm not
sure whether that detail also provides some rationale as to why all
descendants of the threaded root cgroup aren't automatically converted
to type "threaded". Any thoughts about that?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
