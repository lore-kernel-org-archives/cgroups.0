From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Fri, 8 Jan 2016 02:02:20 +0530
Message-ID: <CAG53R5Xy8avVVvfGjgYOJSVRNFOHpiHXrQeEeb41EP4hy370QQ@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<20160105215623.GH5995@mtj.duckdns.org>
	<CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
	<20160107150718.GC29797@mtj.duckdns.org>
	<CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
	<20160107200604.GE1898@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=URF8QSqfnLS7qEIIdA647MeX1bNc1moXSxQ7ilgCK8I=;
        b=x9ojMpWOMKPH0ySpdfexB3FvqTjm18WGMncsIvPqcANHCNJbWvWFxOSpb+pudlrHPt
         6WRUXWLDtsk1MUtSHnLXqM1hUgOWWzxfQAXGp730DhNZbXLeZLYjBYJ+IhNgXjxXjTwW
         7ObcN0j0kL21AIO1kvfofY6acmKvsggVgyFxfJhxQa+fdKZiQSXiwKzqozy7F1eNnpP8
         P/ke+9CpMm+ZKNBjGmZkOJbUue4dG/YiLdahP3OkbbVVsfsU5s5TJvZXe/DmSWp6EF1C
         QP7t1oV+4uJGBKd4lskWYaWjNNJf3z0znlBZUnI0N7J869lIFg0c4kRrwvTK9OX8csYE
         2svg==
In-Reply-To: <20160107200604.GE1898@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Fri, Jan 8, 2016 at 1:36 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Jan 08, 2016 at 01:31:06AM +0530, Parav Pandit wrote:
>> >  What I was
>> > trying to say was that unless the number is extremely high, it'd be
>> > far simpler to hard code them in the rdma controller and let drivers
>> > enable the ones which apply to them.
>>
>> Instead of in rdma controller, its hard coded in IB stack.
>> I see this as an advantage where resource definition ownership remains
>> with IB stack maintainers, rather than rdma cgroup maintainer.
>> rdma cgroup maintainer doesn't have to understand what SRQ vs QP or
>> ODP type MR or multicast group is.
>> IB stack maintainer is better placed to judge and define it.
>>
>> I would like to hear from Jason, Doug, Liran and other RDMA experts
>> about their thoughts.
>
> That's fine.  Make it a header file in IB stack which is included from
> the rdma cgroup controller.  The only things are not building a huge
> dynamic framework for something which can easily be a simple static
> thing and having some oversight in adding resource types.
>
o.k. That doable. I want to make sure that we are on same page on below design.
rpool (which will contain static array based on header file ) would be
still there, because resource limits are on per device basis. Number
of devices are variable and dynamically appear. Therefore rdma_cg will
have the list of rpool attached to it. Do you agree?

> Thanks.
>
> --
> tejun
