From: Michal Hocko <mhocko@kernel.org>
Subject: Re: memory.force_empty is deprecated
Date: Tue, 22 Nov 2016 16:21:52 +0100
Message-ID: <20161122152152.GB6844@dhcp22.suse.cz>
References: <OF57AEC2D2.FA566D70-ON48258061.002C144F-48258061.002E2E50@notes.na.collabserv.com>
 <20161104152103.GC8825@cmpxchg.org>
 <5b03def0-2dc4-842f-0d0e-53cc2d94936f@gmail.com>
 <OF4C17DCE5.3A69F6D5-ON4825806F.00234EAD-4825806F.00238F1A@notes.na.collabserv.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <OF4C17DCE5.3A69F6D5-ON4825806F.00234EAD-4825806F.00238F1A@notes.na.collabserv.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhao Hui Ding <dingzhh@cn.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>

On Fri 18-11-16 14:28:21, Zhao Hui Ding wrote:
> Thank you. 
> Do you mean memory.force_empty won't be deprecated and removed?

The knob will most likely stay in the v1 memcg user api. The warning is
mostly to inform users that it will not be added to the v2 api unless
there is a strong usecase.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
