From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V5 06/14] hugetlb: Simplify migrate_huge_page
Date: Mon, 09 Apr 2012 14:06:33 +0530
Message-ID: <87398de1yl.fsf@skywalker.in.ibm.com>
References: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1333738260-1329-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F8277ED.8040904@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F8277ED.8040904@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> (2012/04/07 3:50), Aneesh Kumar K.V wrote:
>
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> Since we migrate only one hugepage don't use linked list for passing
>> the page around. Directly pass page that need to be migrated as argument.
>> This also remove the usage page->lru in migrate path.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
>
> seems good to me. I have one question below.
>
>
>> ---

...... snip ......


>> -	list_add(&hpage->lru, &pagelist);
>> -	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
>> -				true);
>> +	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);
>> +	put_page(page);
>>  	if (ret) {
>> -		struct page *page1, *page2;
>> -		list_for_each_entry_safe(page1, page2, &pagelist, lru)
>> -			put_page(page1);
>> -
>>  		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
>>  			pfn, ret, page->flags);
>> -		if (ret > 0)
>> -			ret = -EIO;   <---------------------------- here
>>  		return ret;
>>  	}
>>  done:
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 51c08a0..d7eb82d 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -929,15 +929,8 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
>>  	if (anon_vma)
>>  		put_anon_vma(anon_vma);
>>  	unlock_page(hpage);

.... snip .....

>> -
>> -			rc = unmap_and_move_huge_page(get_new_page,
>> -					private, page, pass > 2, offlining,
>> -					mode);
>> -
>> -			switch(rc) {
>> -			case -ENOMEM:
>> -				goto out;
>> -			case -EAGAIN:
>> -				retry++;
>> -				break;
>> -			case 0:
>> -				break;
>> -			default:
>> -				/* Permanent failure */
>> -				nr_failed++;
>> -				break;
>> -			}
>> +			break;
>> +		case 0:
>> +			goto out;
>> +		default:
>> +			rc = -EIO;
>> +			goto out;
>
>
> why -EIO ? Isn't this BUG() ??

I am not sure doing a BUG() for migrate is a good idea. We may want to
return error and let the higher layer handle this. Also as you see in
the two hunks I listed above, default is mapped to -EIO in the current
code. I didn't want to change that.

-aneesh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
