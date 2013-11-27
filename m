From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v11 00/15] kmemcg shrinkers
Date: Wed, 27 Nov 2013 10:26:17 +0400
Message-ID: <52959089.6030607@parallels.com>
References: <cover.1385377616.git.vdavydov@parallels.com> <20131125174135.GE22729@cmpxchg.org> <529443E4.7080602@parallels.com> <20131126224742.GB10988@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131126224742.GB10988@dastard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 11/27/2013 02:47 AM, Dave Chinner wrote:
> On Tue, Nov 26, 2013 at 10:47:00AM +0400, Vladimir Davydov wrote:
>> Hi,
>>
>> Thank you for the review. I agree with all your comments and I'll
>> resend the fixed version soon.
>>
>> If anyone still has something to say about the patchset, I'd be glad
>> to hear from them.
> Please CC me on all the shrinker/list-lru changes being made as I am
> the original author of the list-lru code and the shrinker
> integration and have more than a passing interest in ensuring
> it doesn't get broken or crippled....

Sure, thanks.
