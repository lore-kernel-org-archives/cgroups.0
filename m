From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 01/19] mm: Introduce vm_account
Date: Mon, 23 Jan 2023 22:29:14 -0800
Message-ID: <Y896ugI8HoXDRjp3@infradead.org>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp3.osuosl.org 78C6B60BFF
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp3.osuosl.org 89BE360A69
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp3.osuosl.org 1E03D60BB0
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp3.osuosl.org 66C4360A69
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=4u7sdeygL2SI0vuOn3AQXqOOeojipj5nJ8JBXiSMSP4=; b=Y1N1Bp85zWT1Yc4mWO5RM/5swn
 z1s/ae7nZBU1XI2LeDBAOv+06U0Bu1PJWHXCDrEjlbbph1xr+oh6cmoXIod4hdcTSIhg05KsUMsH6
 Mt0SAUZbeNMdj95LikeyPio6/J/WyHzPQbupOE2KMJ+OXZv8xSLLdBNtO7Ot/A8dx2JalSA7ubKi2
 aFuBB1XW7qW1wiu2y2b/BJd4x/N6dLqevlGltWAruZGC7j2J5NPe6Xz6f5IgVH1uIF87LFk4mGzQ9
 1iI2DWcT8gQ30YpVU8YQ5BM2WIzRNm5oNr5lR1NU6lLpwGy0B15qzrZcjDOK9MRUi3zNGYFfM5749
 r4m38yZA==;
Content-Disposition: inline
In-Reply-To: <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-kselftest@vger.kernel.org, rds-devel@oss.oracle.com, daniel@ffwll.ch, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, jhubbard@nvidia.com, linux-fpga@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org, mkoutny@suse.com, jgg@nvidia.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, surenb@google.com, tjmercier@google.com, io-uring@vger.kernel.org

> +/**
> + * vm_account_init - Initialise a new struct vm_account.
> + * @vm_account: pointer to uninitialised vm_account.
> + * @task: task to charge against.
> + * @user: user to charge against. Must be non-NULL for VM_ACCOUNT_USER.
> + * @flags: flags to use when charging to vm_account.
> + *
> + * Initialise a new uninitialiused struct vm_account. Takes references
> + * on the task/mm/user/cgroup as required although callers must ensure
> + * any references passed in remain valid for the duration of this
> + * call.
> + */
> +void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
> +		struct user_struct *user, enum vm_account_flags flags);


kerneldoc comments are supposed to be next to the implementation, and
not the declaration in the header.
