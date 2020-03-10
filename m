From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCHv2] memcg: fix NULL pointer dereference in
 __mem_cgroup_usage_unregister_event
Date: Tue, 10 Mar 2020 12:17:10 +0100
Message-ID: <20200310111710.GF8447@dhcp22.suse.cz>
References: <077a6f67-aefa-4591-efec-f2f3af2b0b02@gmail.com>
 <20200310094836.GD8447@dhcp22.suse.cz>
 <20200310104149.5c3pc75y6ny5hixb@box>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200310104149.5c3pc75y6ny5hixb@box>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: brookxu <brookxu.cn@gmail.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 10-03-20 13:41:49, Kirill A. Shutemov wrote:
> On Tue, Mar 10, 2020 at 10:48:36AM +0100, Michal Hocko wrote:
> > [Cc Kirill, I didn't realize he has implemented this code]
> 
> My first non-trivial mm contribution :P

Everybody has to pay for sins of youth :p

[...]

> > It seems that the code has been broken since 2c488db27b61 ("memcg: clean
> > up memory thresholds"). We've had 371528caec55 ("mm: memcg: Correct
> > unregistring of events attached to the same eventfd") but it didn't
> > catch this case for some reason. Unless I am missing something the code
> > was broken back then already. Kirill please double check after me.
> 
> I think the issue exitsted before 2c488db27b61. The fields had different
> names back then.
> 
> The logic to make unregister never-fail is added in 907860ed381a
> ("cgroups: make cftype.unregister_event() void-returning"). I believe the
> Fixes should point there.

Yes, you seem to be right. It doesn't make a difference much as both
went in to the same kernel but a proper Fixes tag is really valuable.

Thanks for looking into that.

-- 
Michal Hocko
SUSE Labs
