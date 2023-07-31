From: Dan Carpenter <dan.carpenter-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [bug report] selftests: cgroup: add test_zswap with no kmem bypass
 test
Date: Mon, 31 Jul 2023 10:23:33 +0300
Message-ID: <477f3cd4-d2ec-4a0e-8e77-87968467d4a2@moroto.mountain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690788218; x=1691393018;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lJoYO3abZlnLiViPN3Pe9+sAeSfdHAGtroUhAzE18qk=;
        b=dHg9toW9T2T3EO8tD1JNKX15Xe8ZFGctyxSc7P8ASzkBRRW19wvMTFLZvrT3Z+I1ke
         aNWJsOE3fKyOsSNn/rmR3nKWgx/mSkK5J0/pN3rxMc8uGhNymlXDKgjlHg4jExnAJ9du
         3ybVltdZE4yC15r51bDwNLjqw+bhOtEVBVQvGGSS6YyoQgKNOFu7ZtlM38mSq+m2q7a0
         4V6aI6nPrtNyAaRNyItJb1WmPT/agXH/CoASqZ2bpDahfX12fC9RRKg8ywL941snk0vd
         BkSCTmlvpFHvkb5svuB9j+udzHBCXDARDHgV+1GCRlugbiC7u5ZAX1irP1igFgq0uYIn
         uC8g==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Domenico Cerasuolo,

The patch 7c967f267b1d: "selftests: cgroup: add test_zswap with no
kmem bypass test" from Jun 21, 2023 (linux-next), leads to the
following Smatch static checker warning:

	tools/testing/selftests/cgroup/test_zswap.c:211 test_no_kmem_bypass()
	warn: unsigned 'stored_pages' is never less than zero.

./tools/testing/selftests/cgroup/test_zswap.c
    197         /* Try to wakeup kswapd and let it push child memory to zswap */
    198         set_min_free_kb(min_free_kb_high);
    199         for (int i = 0; i < 20; i++) {
    200                 size_t stored_pages;
    201                 char *trigger_allocation = malloc(trigger_allocation_size);
    202 
    203                 if (!trigger_allocation)
    204                         break;
    205                 for (int i = 0; i < trigger_allocation_size; i += 4095)
    206                         trigger_allocation[i] = 'b';
    207                 usleep(100000);
    208                 free(trigger_allocation);
    209                 if (get_zswap_stored_pages(&stored_pages))
    210                         break;
--> 211                 if (stored_pages < 0)

size_t can't be negative.  Is there any reason to check this even?

    212                         break;
    213                 /* If memory was pushed to zswap, verify it belongs to memcg */
    214                 if (stored_pages > stored_pages_threshold) {
    215                         int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
    216                         int delta = stored_pages * 4096 - zswapped;
    217                         int result_ok = delta < stored_pages * 4096 / 4;
    218 
    219                         ret = result_ok ? KSFT_PASS : KSFT_FAIL;
    220                         break;
    221                 }
    222         }
    223 
    224         kill(child_pid, SIGTERM);

regards,
dan carpenter
