From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Fri, 8 Jan 2016 02:34:49 +0530
Message-ID: <CAG53R5VYr6An5oh+RP2=pV_rDm793R5z+Tj6aRKNUZoTPJ3QCw@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<20160105215623.GH5995@mtj.duckdns.org>
	<CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
	<20160107150718.GC29797@mtj.duckdns.org>
	<CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
	<20160107200604.GE1898@mtj.duckdns.org>
	<CAG53R5Xy8avVVvfGjgYOJSVRNFOHpiHXrQeEeb41EP4hy370QQ@mail.gmail.com>
	<20160107203425.GG1898@mtj.duckdns.org>
	<CAG53R5V80hY2SLrt3-GNeQ-wr+0aFM7sNJLvUGuy70t5dc8yOA@mail.gmail.com>
	<20160107204921.GI1898@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=jQpsdzVrUGrdpq4ReIDxzyYcamSnrXtK9U7x5hAAPAI=;
        b=Z5qzxFi7QiW+o4RpmKXw4gpjV9bpuIZbo/lQzEejCYlFgXh44OTjVFYKZU+YvAYss4
         56S+oU3kyG0p9e6v/0ILw2Gk6SlYgSrugCzXrotJtMgSCH6fjsc06LOjV9eaYh9KGFkk
         T5IxFRZXCWSutiUIIS9dk8ZidpwwagXFpAGzVBMsBumVcbf9QyUFP7adH+ecTtPl8VID
         w5bHpaPol5rEFXa6iJp5055wyr+sSAbc3xaOEbseUizKPF9fscbzsaV4C0oF0D+B3CDg
         jAa9zKTKLap+TQ5/W7nQvbs9hbWOZ4LOrKjfRNOYjjO1mXiZ8XHfmy7FNbdLqYeZnhZt
         YYFQ==
In-Reply-To: <20160107204921.GI1898@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Fri, Jan 8, 2016 at 2:19 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Parav.
>
> On Fri, Jan 08, 2016 at 02:16:59AM +0530, Parav Pandit wrote:
>> Let me think through it. Its been late night for me currently. So dont
>> want to conclude in hurry.
>
> Sure thing.
>
>> At high level it looks doable by maintaining hash table head on per
>> device basis, that further reduces hash contention by one level.
>> I will get back on this tomorrow.
>
> Hmmm... why would it need a hash table?  Let's say there's a struct
> rdma_device for each rdma_device and then that stuct can simply have
> rdma_device->res_table[] or whatever to track limits and consumptions
> and rdma_device->res_enabled mask to tell which resources are enabled
> on the device.
>

That table won't be sufficient, because rdma_device is shared among
multiple rdma_cgroups each such cgroup has different individual
resource limit and usage count. This is currently rpool structure.
For res_table[] needs to be per cgroup basis.


> Thanks.
>
> --
> tejun
