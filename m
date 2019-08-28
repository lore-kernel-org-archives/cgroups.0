From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 0/6] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Wed, 28 Aug 2019 13:23:40 +0200
Message-ID: <20190828112340.GB7466@dhcp22.suse.cz>
References: <20190826233240.11524-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190826233240.11524-1-almasrymina@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: mike.kravetz@oracle.com, shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, khalid.aziz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com, mkoutny@suse.com

On Mon 26-08-19 16:32:34, Mina Almasry wrote:
>  mm/hugetlb.c                                  | 493 ++++++++++++------
>  mm/hugetlb_cgroup.c                           | 187 +++++--

This is a lot of changes to an already subtle code which hugetlb
reservations undoubly are. Moreover cgroupv1 is feature frozen and I am
not aware of any plans to port the controller to v2. That all doesn't
sound in favor of this change. Mike is the maintainer of the hugetlb
code so I will defer to him to make a decision but I wouldn't recommend
that.
-- 
Michal Hocko
SUSE Labs
