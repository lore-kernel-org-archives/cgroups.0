From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v4 2/4] selftests: cgroup: return -errno from
 cg_read()/cg_write() on failure
Date: Sat, 23 Apr 2022 14:01:41 +0000
Message-ID: <20220423140141.si5uke4wwzkbvssv@google.com>
References: <20220421234426.3494842-1-yosryahmed@google.com> <20220421234426.3494842-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=T8hqvwXzMDJqZ8Axnxfnhvq+3Bu/rfhoYjsi7PA4tsE=;
        b=SaaEKps4SdcXrfWLEhDKbRKvWuHqxD/qC9DthlbxTefT8zFbnCkKN6Twt0N/zWPsAU
         kJOzbP+3wq3L1DT7U8hKowgIHXNJSlfhEhCCYfjXkLsVcCgEaWIy3Ga1kCs9Pj1BgVou
         eETAD1Kace93r7bld1JcOoykJwmdEeNQd6b567WNlWqOJMytyl4gEqOx+RfI7++STaz7
         d8WiXLQeQEuCe01HMtqFsrTJopkuQYUY7UetF/X16zSVu9Ac6gXTXRhIO2i3L3SaVbou
         Cju3TdsCK+gMN7LKClrPxs1deGxBu6NTofsZp4LnlYrUunaHT7GuB+5CDuJ5wRWl69ZZ
         nxaA==
In-Reply-To: <20220421234426.3494842-3-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.or

On Thu, Apr 21, 2022 at 11:44:24PM +0000, Yosry Ahmed wrote:
> Currently, cg_read()/cg_write() returns 0 on success and -1 on failure.
> Modify them to return the -errno on failure.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Shakeel Butt <shakeelb@google.com>
