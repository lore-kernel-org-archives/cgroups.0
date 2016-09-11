From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 11 Sep 2016 11:07:57 +0300
Message-ID: <ddbb4d5a-c352-925b-c3db-4f33f3e8ac50@mellanox.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
 <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
 <20160831211618.GA12660@htj.duckdns.org>
 <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
 <20160901084406.GA4115@lst.de>
 <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
 <20160910161442.GC29259@lst.de> <20160910170151.GA5230@obsidianresearch.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aqAkYLrfh/jmcCXAUclzpDyM3yRGa0BVyPJBVf5mAb8=;
 b=IZyWGOc2IU8nzyJ5K3xN34xnopA5S/uJAKYdFs7U9J15EbjTeoQH4F2STb7cJ+D2MxELUHbpqTXnOfTN4D3Q0NJMU4LUQhNLCD8nh149LyQbO6jtdu4NWahCAY1MC/1xPNl/+wKscemqIAktvCHLMsOksMXdrA5sO4SuaQ79eqU=
In-Reply-To: <20160910170151.GA5230-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/09/2016 20:01, Jason Gunthorpe wrote:
> On Sat, Sep 10, 2016 at 06:14:42PM +0200, Christoph Hellwig wrote:
>> OFVWG meetings have absolutely zero relevance for Linux development.
>
> Well, to be fair there are a fair number of kernel developers on that
> particular call..
>
>> More "flexibility" for drivers just means giving up on designing a
>> coherent API and leaving it to drivers authors to add crap to their
>> own drivers.  That's a major step backwards.
>
> Sadly, it isn't a step backwards, it is status quo - at least as far
> as the uapi is concerned.
>
> Every single user space driver has its own private abi file, carefully
> hidden in their driver, and dutifully copied over to user space:
>
> providers/cxgb3/iwch-abi.h
> providers/cxgb4/cxgb4-abi.h
> providers/hfi1verbs/hfi-abi.h
> providers/i40iw/i40iw-abi.h
> providers/ipathverbs/ipath-abi.h
> providers/mlx4/mlx4-abi.h
> providers/mlx5/mlx5-abi.h
> providers/mthca/mthca-abi.h
> providers/nes/nes-abi.h
> providers/ocrdma/ocrdma_abi.h
> providers/rxe/rxe-abi.h
>
> Just to pick two random examples:
>
> struct mlx5_create_cq {
>         struct ibv_create_cq            ibv_cmd;
>         __u64                           buf_addr;
>         __u64                           db_addr;
>         __u32				cqe_size;
> };
>
> struct iwch_create_cq {
>         struct ibv_create_cq ibv_cmd;
>         uint64_t user_rptr_addr;
> };
>
> Love to hear ideas on a way forward that doesn't involve rewriting
> everything :(
>

Yeah, unfortunately, the RDMA ABI is more driver specific ABI than a 
common user-kernel ABI. I guess this will become even worse, as the RDMA 
subsystem is evolving to serve more drivers with different object types. 
For example, I would like to hear how hfi1 are going to define their 
user-kernel ABI (once they leave the custom ioctls).

>> They should not be using the code in drivers/infiniband.  usnic is such
>> an example of a driver that should never have been added in it's current
>> form.
>
> +1
>
> Jason
>

Matan
