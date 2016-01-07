From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Fri, 8 Jan 2016 02:40:02 +0530
Message-ID: <CAG53R5XZfhgZh325=SQyNJr=Cz=AB_ay=Np6Cbm5kh4PSCfpQw@mail.gmail.com>
References: <CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
	<20160107150718.GC29797@mtj.duckdns.org>
	<CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
	<20160107200604.GE1898@mtj.duckdns.org>
	<CAG53R5Xy8avVVvfGjgYOJSVRNFOHpiHXrQeEeb41EP4hy370QQ@mail.gmail.com>
	<20160107203425.GG1898@mtj.duckdns.org>
	<CAG53R5V80hY2SLrt3-GNeQ-wr+0aFM7sNJLvUGuy70t5dc8yOA@mail.gmail.com>
	<20160107204921.GI1898@mtj.duckdns.org>
	<20160107205042.GJ1898@mtj.duckdns.org>
	<CAG53R5WVJoO1Dd9vJ+zeiskQsttSbOpW+uyfay-oJFELd-FK2Q@mail.gmail.com>
	<20160107210752.GK1898@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=RQaVLpnLrqkhJecGdbyNtL8bQpY2kZxiHq+ZZE7IIcE=;
        b=FPIC8DqQdiWYVvka/mAPMKmhWUKooO2qltbKoQiVzv2ESVMLYhSKsO5UlJYSSM55Tz
         wuIVJZ5hWJrp8xifwJUR6jPLAWJz5sqOTlCJAGhdQx+m6AV2UXgs+hQYvcOFs7/7bt4v
         EUAsivOwp/PhWcCT0S6IHfYQKYBWVQwSgpiW67FYS5HIjdXDBUT+9FxqH7P/f42iQY59
         9IHEFsWTtjn2gS4oiEh2mFwMUMKet4NF+cgU5S/Vuj5UAdFv17DFsN/4HQl0nbsak8qi
         qbsDDi2/f9Y9EFUBY6z2TTYxg0m+jN8D6AsYWb9nV/nuyRhYZNCQBfOvHApPi9F2sl0R
         8dZA==
In-Reply-To: <20160107210752.GK1898@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Fri, Jan 8, 2016 at 2:37 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Jan 08, 2016 at 02:31:26AM +0530, Parav Pandit wrote:
>> On Fri, Jan 8, 2016 at 2:20 AM, Tejun Heo <tj@kernel.org> wrote:
>> > Ooh, btw, please don't bother to create separate interfaces for v1 and
>> > v2 hierarchies.  Just creating one following v2 conventions and using
>> > the same thing for v1 should do and is a lot easier for everybody.
>> >
>> Sure. I have already made that change to remove list.
>> and changed rdma.resource.verb.limit to rdma.verb.max etc.
>>
>> I will keep rdma.hw.max around until we get some consensus.
>>
>> Alternatively I was thinking to merge that as another attribute in
>> rdma.max file, like
>>
>> mlx4_0 verb ah=max pd=10 qp=10
>> mlx4_0 hw ah=10 pd=100
>> ocrdma hw ah=10 pd=100
>>
>> This remove hw specific extra file for rare feature.
>
> Hmm... if there are duplicate keys, I think rdma.verb.max and
> rdma.hw.max would be cleaner.
>
ok. I agree. I will keep as you described.

> Thanks.
>
> --
> tejun
