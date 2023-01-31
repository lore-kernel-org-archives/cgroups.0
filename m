From: David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH 01/19] mm: Introduce vm_account
Date: Tue, 31 Jan 2023 15:00:08 +0100
Message-ID: <658eda9c-d716-fcb7-ba0c-b36f646195f1@redhat.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp3.osuosl.org 8B4D860B32
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp3.osuosl.org 20D3360B29
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp4.osuosl.org 39F934160F
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp4.osuosl.org CDB7F40E47
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1675173614;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=sW7aiMox0CriK8aU+HN+jb3vaXSIy6HBnrk2aPiMthI=;
 b=hNBqq1VaLUmj3Gv1bRG7q+5EQCO429IY7U/08wZlnbsDbr814ZlRjHZ0QxfnaGFtdWzpni
 tDLuxG8mKUlU8g0iKrrkVJslJvv5Pg/tJEf+A+xr1EDIPxSAPiLpbQV/Nn1IDqcMMhscrK
 f3/M7EcB/tK+JCmXdbEaboSZ0rFgfhs=
In-Reply-To: <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org, rds-devel@oss.oracle.com, daniel@ffwll.ch, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, jhubbard@nvidia.com, linux-fpga@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, mkoutny@suse.com, jgg@nvidia.com, hannes@cmpxchg.org, bpf@vger.kernel.org, surenb@google.com, tjmercier@google.com, io-uring@vger.kernel.org

On 24.01.23 06:42, Alistair Popple wrote:
> Kernel drivers that pin pages should account these pages against
> either user->locked_vm or mm->pinned_vm and fail the pinning if
> RLIMIT_MEMLOCK is exceeded and CAP_IPC_LOCK isn't held.
> 
> Currently drivers open-code this accounting and use various methods to
> update the atomic variables and check against the limits leading to
> various bugs and inconsistencies. To fix this introduce a standard
> interface for charging pinned and locked memory. As this involves
> taking references on kernel objects such as mm_struct or user_struct
> we introduce a new vm_account struct to hold these references. Several
> helper functions are then introduced to grab references and check
> limits.
> 
> As the way these limits are charged and enforced is visible to
> userspace we need to be careful not to break existing applications by
> charging to different counters. As a result the vm_account functions
> support accounting to different counters as required.
> 
> A future change will extend this to also account against a cgroup for
> pinned pages.

The term "vm_account" is misleading, no? VM_ACCOUNT is for accounting 
towards the commit limit ....

-- 
Thanks,

David / dhildenb
