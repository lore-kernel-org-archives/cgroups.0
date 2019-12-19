From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v9 1/8] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Wed, 18 Dec 2019 17:37:37 -0800
Message-ID: <4d11fb25-5036-6c78-5328-10a0c14e8edc@oracle.com>
References: <20191217231615.164161-1-almasrymina@google.com>
 <20191218171254.79664a964c0c61e6054dff64@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=TESIcPkdV4iqOIUQl0IYI/d2iDoSjKThzSi7PjRQeX4=;
 b=opXrPL1VX9xpx2kpCFKgaXvY5VlJZGU/WOowBs9R9TNvFsZ9dkmHgMCf1W79ij6cjtkq
 BJjiBSRf7VF5bHt5QUpGtfnaQwlwxXy63R8Gjj/gUJ9kCnPg/Fk8NqAhaRlBwwGq2ros
 Axc8lqgv8uZoy6Bt+uuOMN3PawaN2yTgKmkzHOlpiXRXg0cOtd0exrPfYuT9uPhe5vZP
 2SXP+1IpjmI1+h/WPUPoR7zItwpthJIvnOlFfMVDeG5xZ6TCPFUpAaaNJWUww4kmL8Pc
 dKcFVYvb+1SoWn9Ft0BFg5F0abH1kAL5cRl3CeVt84xfRbHlm/JB1C09KYOXuuJOWswJ Wg== 
In-Reply-To: <20191218171254.79664a964c0c61e6054dff64@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com, mkoutny@suse.com, Hillf Danton <hdanton@sina.com>, Giuseppe Scrivano <gscrivan@redhat.com>, Tejun Heo <tj@kernel.org>

On 12/18/19 5:12 PM, Andrew Morton wrote:
> On Tue, 17 Dec 2019 15:16:08 -0800 Mina Almasry <almasrymina@google.com> wrote:
<snip>
>> This proposal is implemented in this patch series, with tests to verify
>> functionality and show the usage. We also added cgroup-v2 support to
>> hugetlb_cgroup so that the new use cases can be extended to v2.
> 
> This would make
> http://lkml.kernel.org/r/20191216193831.540953-1-gscrivan@redhat.com
> obsolete?

I haven't started looking at this series yet.  However, since Mina was
involved in the discussion of that patch (hugetlb controller for cgroups v2)
my assumption is that this patch would simply build on that v2 support?
Seems like the above patch would be a prereq for this series.

Mina, are those assumptions correct and perhaps this is an old/obsolete
comment?  Does this series apply 'on top' of the above patch?  That patch
is already in Andrew's tree.
-- 
Mike Kravetz
