From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: Fix out-of-bounds on the
 buf returned by memory_stat_format
Date: Mon, 14 Sep 2020 12:20:37 +0100
Message-ID: <20200914112037.GA2417148@chrisdown.name>
References: <20200912155100.25578-1-songmuchun@bytedance.com>
 <20200912174241.eeaa771755915f27babf9322@linux-foundation.org>
 <CAMZfGtXNg31+8QLbUMj7f61Yg1Jgt0rPB7VTDE7qoopGCANGjA@mail.gmail.com>
 <20200914091844.GE16999@dhcp22.suse.cz>
 <CAMZfGtXd3DNrW5BPjDosHsz-FUYACGZEOAfAYLwyHdRSpOsqhQ@mail.gmail.com>
 <20200914103205.GI16999@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kLfSmpZKw0IcWAbxwnk8PLqM8595LR3Odif7KTgUXZk=;
        b=NrVooSirCkC89uwDGsSlSp0zG/q+C1jxdMRgf5vGubOWhuYbiNfYYdydkZ3JndP3vc
         6j1Zt4R+v3/omPJt4fTsTB0b5IQG7u4qoZ9UkGKoveS0XQF9k1VBJIsF5vwqHnYw5nbh
         MlxJi+tdMfm8TSZbWKWyyv0HVCHtRKJeEg0u8=
Content-Disposition: inline
In-Reply-To: <20200914103205.GI16999-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Michal Hocko writes:
>> > > Yeah, I think we should cc:stable.
>> >
>> > Is this a real problem? The buffer should contain 36 lines which makes
>> > it more than 100B per line. I strongly suspect we are not able to use
>> > that storage up.
>>
>> Before memory_stat_format() return, we should call seq_buf_putc(&s, '\0').
>> Otherwise, the return buf string has no trailing null('\0'). But users treat buf
>> as a string(and read the string oob). It is wrong. Thanks.
>
>I am not sure I follow you. vsnprintf which is used by seq_printf will
>add \0 if there is a room for that. And I argue there is a lot of room
>in the buffer so a corner case where the buffer gets full doesn't happen
>with the current code.

I don't feel very strongly either way, but in general I agree with Michal. As 
it is this feels quite perfunctory.

If you can demonstrate reading the string out of bounds in a 
userspace-exploitable way -- that is, you can demonstrate one can coerce 
memory.stat to a format where you would read out of bounds -- then we should 
obviously cc stable and keep the Fixes tag, but you have not come close to 
demonstrating this yet.

Otherwise, if you cannot provide any way to read the string out of bounds, 
because the buffer is simply way too big for this to ever happen, this is just 
a code cleanup, and neither Fixes nor stable are appropriate.

So, the question is, which is it? :-)
