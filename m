From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/memcg: fix device private memcg accounting
Date: Mon, 12 Oct 2020 09:28:59 -0400
Message-ID: <20201012132859.GD163830@cmpxchg.org>
References: <20201009215952.2726-1-rcampbell@nvidia.com>
 <20201009155055.f87de51ea04d4ea879e3981a@linux-foundation.org>
 <d1aab0b0-4327-38da-6587-98f1740228fd@nvidia.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pnPTIBXyXY3lw9klvumgMEMiErvTNBjNm3i9R50FiO8=;
        b=vnTw9dJflaMIXNnNWw2vi/vOaGk2yCJ69WDQkdY4C16AMLkPTm9WzibqnJrH3CiqcT
         mJCxscrz0aU5tFQt3oG+TShN2wD1khwShvSZmM7v3nm7O0dWqniUMmRiLZDDQYjBBccN
         EQJUREQlsKPdgYnTyxfYxpHc0vHmAkbUNFICmbFU9qwruHcZYxq++kzYmfP+Jt3WKH/u
         s9pLL3UOpMht2Ts8ZdKF5KM7CdNLZlGJtrvSuo0yDSxa4ZuiVm8uVJZWBNWu3bOhsbRd
         aG5OPdQLY7OH+3bI0F0c0UQ5AwXOA6uNU9dy12iV8LG4GQPFUMJU45SjR9KBubkniWJy
         zj0A==
Content-Disposition: inline
In-Reply-To: <d1aab0b0-4327-38da-6587-98f1740228fd@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ralph Campbell <rcampbell@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Balbir Singh <bsingharora@gmail.com>, Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org

On Fri, Oct 09, 2020 at 05:00:37PM -0700, Ralph Campbell wrote:
> 
> On 10/9/20 3:50 PM, Andrew Morton wrote:
> > On Fri, 9 Oct 2020 14:59:52 -0700 Ralph Campbell <rcampbell@nvidia.com> wrote:
> > 
> > > The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
> > > NULL before checking is_device_private_entry() so device private pages
> > > are never handled.
> > > Fix this by checking for non_swap_entry() after handling device private
> > > swap PTEs.

The fix looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> > But this makes me suspect the answer is "there aren't any that we know
> > of".  Are you sure a cc:stable is warranted?
> > 
> 
> I assume the memory cgroup accounting would be off somehow when moving
> a process to another memory cgroup.
> Currently, the device private page is charged like a normal anonymous page
> when allocated and is uncharged when the page is freed so I think that path is OK.
> Maybe someone who knows more about memory cgroup accounting can comment?

As for whether to CC stable, I'm leaning toward no:

- When moving tasks, we'd leave their device pages behind in the old
  cgroup. This isn't great, but it doesn't cause counter imbalances or
  corruption or anything - we also skip locked pages, we used to skip
  pages mapped by more than one pte, the user can select whether to
  move pages along tasks at all, and if so, whether only anon or file.

- Charge moving itself is a bit of a questionable feature, and users
  have been moving away from it. Leaving tasks in a cgroup and
  changing the configuration is a heck of a lot cheaper than moving
  potentially gigabytes of pages to another configuration domain.

- According to the Fixes tag, this isn't a regression, either. Since
  their inception, we have never migrated device pages.
