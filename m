From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unneeded header files
Date: Mon, 19 Jun 2023 15:42:32 +0800
Message-ID: <5f1d08ea-72af-f287-9ec5-3c485c1e4f0c@huawei.com>
References: <20230617072658.1826560-1-linmiaohe@huawei.com>
 <ZJABkaSdZP+K6dOh@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ZJABkaSdZP+K6dOh-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/6/19 15:19, Michal Hocko wrote:
> On Sat 17-06-23 15:26:58, Miaohe Lin wrote:
>> Remove some unneeded header files. No functional change intended.
> 
> Header inclusion cleanups are certainly welcome but it would be much
> more preferred to explain why those are not needed. As build test follow
> ups show this is much more subtle than it seems.

Will make it clear in v2. Thanks for comment.

