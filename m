From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 14:09:26 +0200
Message-ID: <20150514120926.GF6799@dhcp22.suse.cz>
References: <55536DC9.90200@kyup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55536DC9.90200-6AxghH7DbtA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 13-05-15 18:29:13, Nikolay Borisov wrote:
[...]
> memcg_function_test   22  TFAIL  :  ltpapicmd.c:190: input=4095,
> limit_in_bytes=0
> memcg_function_test   23  TFAIL  :  ltpapicmd.c:190: input=4097,
> limit_in_bytes=4096
> memcg_function_test   24  TFAIL  :  ltpapicmd.c:190: input=1,
> limit_in_bytes=0

Before we go and fix these test cases. Do they make any sense at all?
Why should anybody even care that the limit is in page units? I do not
see anything like that mentioned in the documentation. Sure having
the limit in page size units makes a lot of sense from the
implementation POV but should userspace care? Would something break if
we change internals and allow also !page_aligned values? I have hard
time to imagine that.
-- 
Michal Hocko
SUSE Labs
