From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: Re: [PATCH 16/17] cgroup/drm: Expose memory stats
Date: Wed, 26 Jul 2023 17:44:28 +0100
Message-ID: <8959f665-4353-3630-a6c7-5dca60959faa@linux.intel.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-17-tvrtko.ursulin@linux.intel.com>
 <ZLsFBHqCQdPHoZVw@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1690389876; x=1721925876;
 h=message-id:date:mime-version:subject:to:cc:references:
 from:in-reply-to:content-transfer-encoding;
 bh=4yYCYMS1X5+8+dKZLjO0tNUiV3DOrWeoyubjzbdu4rY=;
 b=QYmyWShxHwr52uPIUZ8l/V+HHrXshhcKDHfB3v9LBiQejEX1WHPMYWwy
 w4IqQKSxXslelUQYy+kGwnyIU6WC09fCfMcNiAPqigVS8adMk2ooflvgi
 9g7tG/45We64uirdScr2TAAXpSsmHA7FL68/6XurwtGasQ+ppPnUJfIRb
 XlOMkw0P3k+kYPUka3zkIwXcyrSF278CmihtjgzMH/AiTqtXrWtk6zDN/
 i/Dvh9S+Ud2job5DMFqVGyOis56wnnKNaPhW95EbsnVObsQdVY/gM11e/
 l6Y36eTVvwNOj8wae/laaXytgf17/4G66aIiPfzumHi0DrutwsNj6mYZ0 Q==;
Content-Language: en-US
In-Reply-To: <ZLsFBHqCQdPHoZVw@slm.duckdns.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Dave Airlie <airlied@redhat.com>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Eero Tamminen <eero.t.tamminen@intel.com>, "T . J . Mercier" <tjmercier@google.com>


On 21/07/2023 23:21, Tejun Heo wrote:
> On Wed, Jul 12, 2023 at 12:46:04PM +0100, Tvrtko Ursulin wrote:
>>    $ cat drm.memory.stat
>>    card0 region=system total=12898304 shared=0 active=0 resident=12111872 purgeable=167936
>>    card0 region=stolen-system total=0 shared=0 active=0 resident=0 purgeable=0
>>
>> Data is generated on demand for simplicty of implementation ie. no running
>> totals are kept or accounted during migrations and such. Various
>> optimisations such as cheaper collection of data are possible but
>> deliberately left out for now.
>>
>> Overall, the feature is deemed to be useful to container orchestration
>> software (and manual management).
>>
>> Limits, either soft or hard, are not envisaged to be implemented on top of
>> this approach due on demand nature of collecting the stats.
> 
> So, yeah, if you want to add memory controls, we better think through how
> the fd ownership migration should work.

It would be quite easy to make the implicit migration fail - just the 
matter of failing the first ioctl, which is what triggers the migration, 
after the file descriptor access from a new owner.

But I don't think I can really add that in the RFC given I have no hard 
controls or anything like that.

With GPU usage throttling it doesn't really apply, at least I don't 
think it does, since even when migrated to a lower budget group it would 
just get immediately de-prioritized.

I don't think hard GPU time limits are feasible in general, and while 
soft might be, again I don't see that any limiting would necessarily 
have to run immediately on implicit migration.

Second part of the story are hypothetical/future memory controls.

I think first thing to say is that implicit migration is important, but 
it is not really established to use the file descriptor from two places 
or to migrate more than once. It is simply fresh fd which gets sent to 
clients from Xorg, which is one of the legacy ways of doing things.

So we probably can just ignore that given no significant amount of 
memory ownership would be getting migrated.

And for drm.memory.stat I think what I have is good enough - both 
private and shared data get accounted, for any clients that have handles 
to particular buffers.

Maarten was working on memory controls so maybe he would have more 
thoughts on memory ownership and implicit migration.

But I don't think there is anything incompatible with that and 
drm.memory.stats as proposed here, given how the categories reported are 
the established ones from the DRM fdinfo spec, and it is fact of the 
matter that we can have multiple memory regions per driver.

The main thing that would change between this RFC and future memory 
controls in the area of drm.memory.stat is the implementation - it would 
have to get changed under the hood from "collect on query" to "account 
at allocation/free/etc". But that is just implementation details.

Regards,

Tvrtko
