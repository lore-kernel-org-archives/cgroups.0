From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: drop unnecessary cold-path tests from
 __memcg_kmem_bypass()
Date: Mon, 14 Sep 2015 15:51:11 +0300
Message-ID: <20150914125111.GF30743@esperanza>
References: <20150913201416.GC25369@htj.duckdns.org>
 <20150913201442.GD25369@htj.duckdns.org>
 <20150913201509.GE25369@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150913201509.GE25369-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sun, Sep 13, 2015 at 04:15:09PM -0400, Tejun Heo wrote:
> __memcg_kmem_bypass() decides whether a kmem allocation should be
> bypassed to the root memcg.  Some conditions that it tests are valid
> criteria regarding who should be held accountable; however, there are
> a couple unnecessary tests for cold paths - __GFP_FAIL and
> fatal_signal_pending().
> 
> The previous patch updated try_charge() to handle both __GFP_FAIL and
> dying tasks correctly and the only thing these two tests are doing is
> making accounting less accurate and sprinkling tests for cold path
> conditions in the hot paths.  There's nothing meaningful gained by
> these extra tests.
> 
> This patch removes the two unnecessary tests from
> __memcg_kmem_bypass().
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
