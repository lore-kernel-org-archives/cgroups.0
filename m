From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/4] mm: Fix clean_record_shared_mapping_range kernel-doc
Date: Sat, 19 Aug 2023 17:51:55 -0700
Message-ID: <26481804-ae24-beb9-9374-8050b4ac070a@infradead.org>
References: <20230818200630.2719595-1-willy@infradead.org>
 <20230818200630.2719595-4-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=gr55w12BJ8HanXJKtEGmjMkhrZT3R55wNuvQW7dICuQ=; b=IrDzPDlxB0+dYccoVG43B3F+hs
        1OlUNYHcISxSlyVVSc8T51Mwcg65C6q7VnWkafRYHxD3dFvEEYGtOD9KEAxSoCDJ7Da2puA3fGkV9
        eJ9DywZDzWlFeQpO6QKeCnC4Nhawgm/ffygvpMOLaYAMyt4FSo8DZwi7el7OMOEMWRmJmFIPkyl4/
        VsrXJBWypxSwzvTdjaAoEnPmgcgfnsQ0jxjx4encoHDS/EKYzfUkCGWXxCaKII0nRHQbhAu4t+uFj
        3zFVvICX17teJDcJ0YRGuXgvRB/943ATEPGfLkYE3q0wxfxCv3R3hZvABPRqbfAUqPptEsuPX43Q/
        q1FIV9rQ==;
Content-Language: en-US
In-Reply-To: <20230818200630.2719595-4-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 8/18/23 13:06, Matthew Wilcox (Oracle) wrote:
> Turn the a), b) into an unordered ReST list and remove the unnecessary
> 'Note:' prefix.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Thanks.

> ---
>  mm/mapping_dirty_helpers.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
> index a26dd8bcfcdb..2f8829b3541a 100644
> --- a/mm/mapping_dirty_helpers.c
> +++ b/mm/mapping_dirty_helpers.c
> @@ -288,13 +288,14 @@ EXPORT_SYMBOL_GPL(wp_shared_mapping_range);
>   * @end: Pointer to the number of the last set bit in @bitmap.
>   * none set. The value is modified as new bits are set by the function.
>   *
> - * Note: When this function returns there is no guarantee that a CPU has
> + * When this function returns there is no guarantee that a CPU has
>   * not already dirtied new ptes. However it will not clean any ptes not
>   * reported in the bitmap. The guarantees are as follows:
> - * a) All ptes dirty when the function starts executing will end up recorded
> - *    in the bitmap.
> - * b) All ptes dirtied after that will either remain dirty, be recorded in the
> - *    bitmap or both.
> + *
> + * * All ptes dirty when the function starts executing will end up recorded
> + *   in the bitmap.
> + * * All ptes dirtied after that will either remain dirty, be recorded in the
> + *   bitmap or both.
>   *
>   * If a caller needs to make sure all dirty ptes are picked up and none
>   * additional are added, it first needs to write-protect the address-space

-- 
~Randy
