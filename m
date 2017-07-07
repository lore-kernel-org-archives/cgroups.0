From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/15] kernel: convert perf_event_context.refcount from
 atomic_t to refcount_t
Date: Fri, 7 Jul 2017 11:27:45 +0200
Message-ID: <20170707092745.3bxg3omd5pbly6rd@hirez.programming.kicks-ass.net>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
 <1499418269-3686-7-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=81hhmGVJnMbidjCYNj7Q7ka4u5bFb4vggFVmdaVbuDQ=; b=R7XDbso4vJii6mi3zVR9FGnww
        Ka7o/ZJmFW7kF5ElwShTc1CiHpcum/DdzA9USPfs3C7OIoz1tSDmBnxQLBTOVeq6AC9fAFQsdHwsX
        KPWvbduEPvEguZjQT7ke9wA5Aohhu5gzGWdkSyzlK9IY6F1V2kaTsHoUZxrL/caIobtEjIjAvCYfQ
        aHX4BmkAYgGqnpWaWZiNBCe8UyNkZ/X25x6kyiQ+fT3i6CEAaC35ZAOK3dJEBVwdYtRH6e4AUd18d
        IV8gy6eOfgD0QcIfk4F1V6/yfK94XbGtE3Ga9Mb7y5noTtB1uMtZDJTg9V0F58OEoerjn+qX06ssu
      
Content-Disposition: inline
In-Reply-To: <1499418269-3686-7-git-send-email-elena.reshetova@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>

On Fri, Jul 07, 2017 at 12:04:20PM +0300, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Windsor <dwindsor@gmail.com>

That's an invalid SoB chain.. can't do anything with these patches.
