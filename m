From: Mahesh Bandewar <maheshb@google.com>
Subject: Re: [PATCH 2/5] net: add bind/listen ranges to net cgroup
Date: Mon, 15 Aug 2016 12:05:40 -0700
Message-ID: <CAF2d9jgbFNTm7oZ7kk0Xcjj7EAbMHE5wUpHgPQ8ZQ=D7FvFXcg@mail.gmail.com>
References: <1470876798-4024-1-git-send-email-anaravaram@google.com>
 <1470876798-4024-3-git-send-email-anaravaram@google.com> <20160813042907.GA55856@ast-mbp.thefacebook.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Vt4E3ZIdey617qoQ+PdFE+HtYtPiDkOF1IDw2O2v5gQ=;
        b=nN1RCqrs1ipZ0l5ToTq6PsALCXcapsPdUZE4+BZGWDtx8e7h6+bD/u94/ezPugmgQS
         YtmCrBXv1YgTXV0n14wYt0SZOMW7omCg9xfsSql2APsGGc4Z/5lSQgntLvKPrsKSQwl2
         hSCaes30330NEtsXdxhISLN8QIWfQuTItjBtKM6xhb8GxsMVWptn/j8BmfLaSmgIn7WZ
         i6DFE9RwwyRYMm1LncTvQDf4gafUDYTavG2YBCK7TmP9TdUfO1nhkFwM9TYeoVO2ORjR
         HRnTZD9CQQ+uC95NFnwC9WKozf4djSSv3AvoIaXZT1J8CeAUFmIUNsKn5S1p9t7OWbil
         0KLQ==
In-Reply-To: <20160813042907.GA55856@ast-mbp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Anoop Naravaram <anaravaram@google.com>, corbet@lwn.net, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>, tom@herbertland.com

On Fri, Aug 12, 2016 at 9:29 PM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
[...]
>> +static bool range_in_ranges(struct net_range *r, struct net_ranges *rs)
>> +{
>> +     int ri;
>> +
>> +     for (ri = 0; ri < rs->num_entries; ri++)
>> +             if (r->min_value >= rs->range[ri].min_value &&
>> +                 r->max_value <= rs->range[ri].max_value)
>> +                     return true;
>> +
>> +     return false;
>> +}
>> +
>> +/* Returns true if all the ranges in rs1 are subsets of at least one of the
>> + * ranges in rs2, ans returns false otherwise.
>> + */
>> +static bool ranges_in_ranges(struct net_ranges *rs1, struct net_ranges *rs2)
>> +{
>> +     int ri;
>> +
>> +     for (ri = 0; ri < rs1->num_entries; ri++)
>> +             if (!range_in_ranges(&rs1->range[ri], rs2))
>> +                     return false;
>> +
>> +     return true;
>> +}
>
> This is not a scalable implementation. The next step would be to
> do a binary search, hash table or something else here?
> I think the root of the problem is in hard coded checks
> that quickly become inefficient and inadequate as applicability
> of the feature grows.
> We already have BPF that can suite this purpose much better
> without bloating the kernel code with parsing and matching logic.
>
This is not a per packet cost and mostly paid once when you are
establishing the channel. Having said that I do agree with you that
the check can be optimized by doing something like a hash-table etc.

This is an ABI extension to the cgroup so having the code where it is
now makes sense to maintain that ABI compatibility. Implementing using
something else (e.g. eBPF etc.) would just mean that this code needs
to be just moved at a different place than the current place so the
net gain would be nothing.
