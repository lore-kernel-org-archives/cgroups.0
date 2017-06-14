From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [HMM-CDM 0/5] Cache coherent device memory (CDM) with HMM
Date: Wed, 14 Jun 2017 14:20:23 -0700
Message-ID: <8219f8fb-65bb-7c6b-6c4c-acc0601c1e0f@intel.com>
References: <20170614201144.9306-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170614201144.9306-1-jglisse@redhat.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: John Hubbard <jhubbard@nvidia.com>, David Nellans <dnellans@nvidia.com>, cgroups@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Balbir Singh <balbirs@au1.ibm.com>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>

On 06/14/2017 01:11 PM, Jérôme Glisse wrote:
> Cache coherent device memory apply to architecture with system bus
> like CAPI or CCIX. Device connected to such system bus can expose
> their memory to the system and allow cache coherent access to it
> from the CPU.

How does this interact with device memory that's enumerated in the new
ACPI 6.2 HMAT?  That stuff is also in the normal e820 and, by default,
treated as normal system RAM.  Would this mechanism be used for those
devices as well?

http://www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
