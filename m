From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] kernfs: attach uuid for every kernfs and report it in
 fsid
Date: Mon, 31 Jul 2023 21:08:41 +0200
Message-ID: <20230731-raubzug-imposant-ef57be965397@brauner>
References: <20230731184731.64568-1-ivan@cloudflare.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690830526;
        bh=nRBJMPp0sswdctWCTu+S7qVu3zqxXdAcDEbnShpEQW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UjkZnK+t0wOVDp1QOAPx6ZoWCsvFM50FrgFaQfBlSKUvA7D4FqoB/A6JDo0q3AQq5
         4l+apP61ADKhwdHownNGFjTUGWS1MDbHF4DYRdzXGQoUjtlU5gKAcuM19smIvFwK0a
         KSagBxXRU91qOXCwdNbxjgImvMMTphF0Ue3Lj4lRjyhzi13RGxTpDcqcOrmXs27dJR
         Zv7IZNGTsCrbpoMQ/f+ufD4Ow7kNil+Q9r1+6MRQsvJYeneMnWTAI6R1xNTZ2lcuYN
         v7I3DS9/RknRsMOuKJLqQffUEpQNSMvhoLgNyDsE37HLwSotV1AV0rMr1ObgZTbMil
         y/ajxqtemKP6A==
Content-Disposition: inline
In-Reply-To: <20230731184731.64568-1-ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, Jul 31, 2023 at 11:47:31AM -0700, Ivan Babrou wrote:
> The following two commits added the same thing for tmpfs:
> 
> * commit 2b4db79618ad ("tmpfs: generate random sb->s_uuid")
> * commit 59cda49ecf6c ("shmem: allow reporting fanotify events with file handles on tmpfs")
> 
> Having fsid allows using fanotify, which is especially handy for cgroups,
> where one might be interested in knowing when they are created or removed.
> 
> Signed-off-by: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
> Acked-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> 
> ---

Acked-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
