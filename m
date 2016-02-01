From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Tue, 2 Feb 2016 00:29:14 +0530
Message-ID: <CAG53R5U=ojbn5tQoq=xR0DUb3Tm6yw+oO6mXVAQ2cUOhbvCdKQ@mail.gmail.com>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
	<1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
	<20160130183015.GP32380@htj.duckdns.org>
	<CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
	<20160131100237.GS32380@htj.duckdns.org>
	<CAG53R5WOLA_=gD9qVnsVk_oPs0iyacL3M+1qD+RAbrnciVXEOA@mail.gmail.com>
	<20160131110420.GV32380@htj.duckdns.org>
	<CAG53R5XXaW-fhb9megcp+Xnv05bSuonDws2fE-D6Wk3JNqS2Aw@mail.gmail.com>
	<20160201184046.GD14091@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=S64za61pQqKjPqvnS1eHWa8GJQPA0qar14O7SYv8o6Q=;
        b=uwT2Wxds20mxYb0Yq3YlJQJEIJfCYNQug83w0lN86CFVgpQm9Ni/WLCh3967V6HgGQ
         fkDcCsRSyPh/TfgO0dgP2tBsVPQ8xtc3FjJyuRYILyMrEda+GQuNn8hBwKcR5c1XLfbZ
         0Yd224bUTLpbeB8p4Pe4G1Jfmf+aSYP3WW8FYReRtb6X1n9ZkiHsCX/+oQMPNsAl4PfS
         ZgBEsd4K7FSdoiMvPLXgw1wEs+o5i1igu1UAw0KBeul+vobhXylZ21GUFAApDMrQtF9K
         dKDzKItLxNftnZKqE3fZBuM1tLNR/0NOuqamGYbWSnz4UucE4VIC8RW/T3rGhPLEvxl+
         7E8A==
In-Reply-To: <20160201184046.GD14091@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Tue, Feb 2, 2016 at 12:10 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Parav.
>
> On Sun, Jan 31, 2016 at 11:20:45PM +0530, Parav Pandit wrote:
>> > Yes, it can.  It just becomes a part of kernel ABI that the IB stack
>> > module depends on.
>> >
>> o.k. Its doable, but I believe its simple but its restrictive.
>
> The whole point is to make it somewhat restrictive so that low level
> drivers don't go crazy with it and the defined resources are clearly
> identified and documented.
>
>> If rest of the RDMA experts are ok with it, I will change it to do it that way.
>> We get to hear their feedback before we put this as ABI.
>
> So, I'm really not gonna go for individual drivers defining resources
> on their own.  That's a trainwreck waiting to happen.  There needs to
> be a lot more scrutiny than that.
>
Not every low level driver. I started with that infrastructure in
v2,v3 but I got your inputs and
I align with that. It could be just single IB stack in one header file
in one enum list would be sufficient.
You have already given that example.
With that mostly two resource type that I have can also shrink to just
single type.
Will wait to hear from them, in case if they have any different thought.


>> >> Now coming to remove command's need.
>> >> If user has previously configured limit of say mr=15. Now if wants to
>> >> remove that configuration and don't want to bother for the limit.
>> >> So the way, its done is by issuing "remove" command.
>> >> Should I name is "reset".
>> >
>> > How is this different from setting the limits to max?
>>
>> We can set it to max. But during freeing time, checking array of 10+
>> elements whether its max or not, didn't find efficient either.
>
> So, in terms of user interface, it doesn't buy anything, right?  It's
> generally a bad idea to mix implementation details like "checking 10+
> elems on free" with interface decisions.  If the overhead of scanning
> the array matters, it can easily be resolved by keeping the count of
> non-max values.
>
> It could be that setting all attributes to "max" is inconvenient from
> interface POV (I don't think this would be a common use case tho).  If
> so, please justify that, update the interface conventions along with
> other similar knobs.  Don't introduce one-off custom thing.
>
ok. setting all values to max is not really a common use case. So I
believe its ok to do that and therefore remove "remove" option.

> ...
>> If we don't do this, and wait until device destruction, rpool just
>> keeps growing!
>>
>> I think above is more important design aspect than just saving memory to me.
>>
>> Let me know if you have different design thought here.
>> (Like engineering can_attach() callback in rdma_cgroup, which I don't
>> see necessary either).
>
> Pin the css while things are in flight and free from css_free?

Yes. Thats what is done in current patch. css_get on charge and
css_put on uncharge, that takes care nicely to free the rpool.

>
>> > If you wanna insist on freeing them dynamically, free them when both
>> > their usages and configs are nil.
>> Agree. Thats what the code is doing using marking object type being default.
>> If I remove the object type, as alternative,
>
> You don't need object type for that.  Think about it again.  All you
> need is a refcnt and cgroup already has a facility for that.
>
ok. Let me attempt that.

I will wait for day or two before I roll out v6 to get any feedback if
Liran, Haggai or Doug has any comments on definition part for resource
type.


> Thanks.
>
> --
> tejun
