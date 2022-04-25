From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v5 4/4] selftests: cgroup: add a selftest for
 memory.reclaim
Date: Mon, 25 Apr 2022 12:21:09 -0700 (PDT)
Message-ID: <935cf8de-c089-a212-f419-fd8434936b5@google.com>
References: <20220425190040.2475377-1-yosryahmed@google.com> <20220425190040.2475377-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=EFTgBEagFmmR6U52RrsmJyFD9yVowcStiIMc2bUDapY=;
        b=s6195XWETsb6HUd7XIYfd+aHSTXLySbeqIstQZ7ENlOt0PPlWQyDgbZ9COFCiAyAKc
         Q151crBFWVCD43gsDQDwAUFRwSreTwwCC10Z+KVQufEFhNcJCLx1dzi19yeK6JlbA099
         FSZXM4DmqpyY5IWjLmZwPAAWufIZsB9qKLxyLLCknVBSjHREAjIzjw67XLWULUs8TEAu
         eEHvwUfUHV/isVdOZmaVCsr48fzvEWkCvu2MO02pyT6ED6PbZ4EqCz/TDMUjSRW+a0oU
         XE9npOj+CyL5GbXgQ1rnJKE53PedmKLmk15elLhmajNbzqfsuukD806Y+AihCB4hq/M2
         /FGg==
In-Reply-To: <20220425190040.2475377-5-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org

On Mon, 25 Apr 2022, Yosry Ahmed wrote:

> Add a new test for memory.reclaim that verifies that the interface
> correctly reclaims memory as intended, from both anon and file pages.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: David Rientjes <rientjes@google.com>
