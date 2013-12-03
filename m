From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v12 05/18] fs: do not use destroy_super() in alloc_super()
 fail path
Date: Tue, 3 Dec 2013 17:48:52 +0400
Message-ID: <529DE144.8020005@parallels.com>
References: <cover.1385974612.git.vdavydov@parallels.com> <af90b79aebe9cd9f6e1d35513f2618f4e9888e9b.1385974612.git.vdavydov@parallels.com> <20131203090041.GB8803@dastard> <529DA2F5.1040602@parallels.com> <20131203133755.GJ10323@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131203133755.GJ10323@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, hannes@cmpxchg.org, mhocko@suse.cz, dchinner@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, glommer@openvz.org

On 12/03/2013 05:37 PM, Al Viro wrote:
> On Tue, Dec 03, 2013 at 01:23:01PM +0400, Vladimir Davydov wrote:
>
>> Actually, I'm not going to modify the list_lru structure, because I
>> think it's good as it is. I'd like to substitute it with a new
>> structure, memcg_list_lru, only in those places where this functionality
>> (per-memcg scanning) is really needed. This new structure would look
>> like this:
>>
>> struct memcg_list_lru {
>>     struct list_lru global_lru;
>>     struct list_lru **memcg_lrus;
>>     struct list_head list;
>>     void *old_lrus;
>> }
>>
>> Since old_lrus and memcg_lrus can be NULL under normal operation, in
>> memcg_list_lru_destroy() I'd have to check either the list or the
>> global_lru field, i.e. it would look like:
>>
>> if (!list.next)
>>     /* has not been initialized */
>>     return;
>>
>> or
> ... or just use hlist_head.

list_head serves as a list node here (those structures are organized in
a linked list) and I have to remove it from the list upon destruction so
hlist_head is not relevant here.

Thanks.
